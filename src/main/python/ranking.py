import os
import sys
import pandas as pd
import requests  	# HTTP 요청
import json			# JSON 데이터 송수신
import re  			# 정규표현식을 쓰기 위해 추가
from datetime import datetime, timedelta
from dotenv import load_dotenv		# 환경변수 사용


load_dotenv()	# 환경변수 불러오기

CLIENT_ID = os.getenv('NAVER_AD_API_CLIENT_ID')
CLIENT_SECRET = os.getenv('NAVER_AD_API_CLIENT_SECRET')

# HTML 태그를 제거하는 함수
def clean_html(text):
	# "<로 시작하고 >로 끝나는 태그 전체" -> HTML 태그를 제거
	return re.sub(r'<.*?>', '', text)

def ranking_data(category):
	# 디버깅 코드(스프링부트 실행 시 주석)
	# print("▶ 시작 - 카테고리:", category, file=sys.stderr)
	# print("▶ CLIENT_ID:", CLIENT_ID, file=sys.stderr)
	# print("▶ CLIENT_SECRET:", CLIENT_SECRET, file=sys.stderr)
	
	# 카테고리 분기
	if category == "foliage":
		category_name = "관엽식물"
		search_word = "관엽식물"
		plants_path = os.path.join(os.path.dirname(__file__), 'resData', '관엽식물사전.csv')
	elif category == "farm":
		category_name = "텃밭식물"
		search_word = "텃밭식물"
		plants_path = os.path.join(os.path.dirname(__file__), 'resData', '텃밭식물사전.csv')
	else:
		return {"error": "카테고리 분기 오류입니다."}

	# csv 파일 읽기
	try:
		plants_df = pd.read_csv(plants_path)
		# print("파일 읽기 완료:", plants_path, file=sys.stderr)
	except FileNotFoundError:
		print("파일 없음:", plants_path, file=sys.stderr)
		return {"error": "식물 사전 파일을 찾을 수 없습니다."}


	# 네이버 쇼핑 API 호출 준비
	url = "https://openapi.naver.com/v1/search/shop.json"
	headers = {
		"X-Naver-Client-Id": CLIENT_ID,
		"X-Naver-Client-Secret": CLIENT_SECRET
	}
	params = {
		"query": search_word,
		"display": 50,		# 검색결과 요청개수
		"sort": "sim"		# 관련도순 정렬
	}
	
	# API 요청 보내기(get방식)
	response = requests.get(url, headers=headers, params=params)
	# print("쇼핑 API 응답 코드:", response.status_code, file=sys.stderr)
	if response.status_code != 200:
		return {"error": "네이버 쇼핑 API 오류"}
	
	# 검색 결과에서 제목 추출
	items = response.json().get('items', [])
    # 쇼핑 검색 결과 제목에서 HTML 태그 제거 후 저장
	titles = [clean_html(item['title']) for item in items]
	
	# 제목에 포함된 식물키워드만 모아 저장할 set(중복 제거를 위해 set 사용)
	matched_keywords = set()  
	# csv에서 읽은 식물이름 목록 읽기
	for _, row in plants_df.iterrows():
		name = str(row['이름']).strip()  # 이름 공백 제거
		if pd.notna(name):  # 이름이 비어있지 않은 경우만
			# 정확한 식물의 단어 일치
			pattern = r'\b' + re.escape(name) + r'\b'  	# re.escape(name) : 식물 이름 안에 특수문자가 있어도 안전하게 처리 / r'\b' : 단어 경계(시작 또는 끝)
			# 아까 뽑아낸 제목 리스트에 식물이름이 정확히 들어가있는지 확인. 있으면 matched_keywords에 식물 이름 추가.
			if any(re.search(pattern, title) for title in titles):
				matched_keywords.add(name)
	
	# matched_keywords 값들 중 값이 있는 것만 담기
	keywords = [kw for kw in matched_keywords if kw]
	# print("매칭된 키워드:", keywords, file=sys.stderr)
	if not keywords:
		print("매칭된 식물 키워드 없음", file=sys.stderr)
		return {"error": "검색 키워드 없음"}

	# 네이버 Datalab API 호출
	# 날짜범위 설정
	end = datetime.now()
	start = end - timedelta(days=30)		# 오늘날짜 기준 30일 전
	start_str = start.strftime('%Y-%m-%d')	# "YYYY-MM-DD" 형식의 문자열로 변환
	end_str = end.strftime('%Y-%m-%d')
	
	# Datalab API 요청 준비
	datalab_url = "https://openapi.naver.com/v1/datalab/search"
	datalab_headers = {
		"X-Naver-Client-Id": CLIENT_ID,
		"X-Naver-Client-Secret": CLIENT_SECRET,
		"Content-Type": "application/json"
	}
    
	all_chart_data = []
	
	# 5개씩 잘라서 API 요청 반복
	for i in range(0, len(keywords), 5):
		chunk = keywords[i:i+5]
		keyword_groups = [{"groupName": kw, "keywords": [kw]} for kw in chunk]
		# 요청 본문
		body = {
			"startDate": start_str,
			"endDate": end_str,
			"timeUnit": "date",
			"keywordGroups": keyword_groups,
			"device": "pc",
			"ages": [],
			"gender": ""
		}
	# POST방식 요청
		dl_response = requests.post(
			datalab_url,
			headers=datalab_headers,
			json=body
		)
		if dl_response.status_code != 200:
			print("에러 응답:", dl_response.text, file=sys.stderr)
			continue
	
		result = dl_response.json()
		# result['results']: Datalab API가 보내주는 키워드별 검색량 데이터
		# group['data']: 날짜별 검색량 비율들이 들어있는 리스트
		# sum(...): 날짜별 비율을 다 더해서 총 검색량 점수로 계산
		for group in result['results']:
			name = group['title']
			volume = sum(item['ratio'] for item in group['data'])
			all_chart_data.append({"name": name, "volume": volume})
    
	# 이미지 맵핑  
	image_map = {
		"딸기": "./images/ranking/strawberry.jpg",
		"토마토": "./images/ranking/tomato.jpg",
		"당근": "./images/ranking/carrot.jpg",
		"수박": "./images/ranking/watermelon.jpg",
		"양배추": "./images/ranking/cabbage.jpg",
		"바질": "./images/ranking/basil.jpg",
	}
    
	# top10 데이터 뽑기
	top10 = []
	# sorted(...): 검색량(volume)이 높은 순서대로 정렬
	for item in sorted(all_chart_data, key=lambda x: x["volume"], reverse=True)[:10]:
		name = item["name"]
		top10.append({
			"name": name,
			"volume": item["volume"],
			"image": image_map.get(name, "./images/default.jpg")
		})
	
	# 결과 반환
	return {
			"top10": top10,
			"category_name": category_name
	}
	
if __name__ == "__main__":
	try:
		# category는 자바에서 인자로 넘기므로 sys.argv로 받기
		category = sys.argv[1]
		result = ranking_data(category)
		print(json.dumps(result, ensure_ascii=False))
	except Exception as e:
		import traceback
		print("py파일 실행 중 예외 발생:", file=sys.stderr)
		traceback.print_exc()
