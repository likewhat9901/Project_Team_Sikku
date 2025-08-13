import pandas as pd
from sklearn.svm import SVR
import numpy as np
import json
import argparse
from pathlib import Path
import sys

# 데이터 로드(텃밭식물만)
# 실내식물 : 몬스테라, 스투키, 오렌지쟈스민, 홍콩야자
# 텃밭식물 : 방울토마토, 오이, 파프리카

def outdoor_json(csv_dir):
    results = {}
    
     # python/resData/predict 폴더 내에서 *.csv만 순회
    for f in Path(csv_dir).glob("*.csv"):
        # 식물 이름 추출 (예: 몬스테라.csv -> 몬스테라)
        plant_name = f.stem
            
        # 구분자/인코딩 자동 감지 (탭/콤마, BOM 대응)
        try:
            df = pd.read_csv(f, encoding="utf-8-sig", sep=None, engine="python")
        except Exception:
            df = pd.read_csv(f, sep=None, engine="python")

        # 헤더 정규화: BOM 제거, 공백 제거, 소문자화
        df.columns = (df.columns
                        .str.replace('\ufeff', '', regex=False)
                        .str.strip().str.lower())
        
        # 공통 데이터                  
        X = df[['date']].values
        y_height = df['height'].values

        # SVR 모델 학습 - 길이
        svr_height = SVR(kernel='rbf', C=100, epsilon=0.1)
        svr_height.fit(X, y_height)

        # 다음 주차 예측
        next_week = X.max() + 1
        pred_height = svr_height.predict([[next_week]])[0]

		# fruitnum이 있을 때만 처리
        has_fruit = 'fruitnum' in df.columns
        if has_fruit:
            y_fruitnum = df['fruitnum'].values
            svr_fruit = SVR(kernel='rbf', C=100, epsilon=0.1)
            svr_fruit.fit(X, y_fruitnum)
            pred_fruit = float(svr_fruit.predict([[next_week]])[0])
        else:
            pred_fruit = None
            
        # 원본 데이터를 JSON 직렬화 가능한 형태로 변환
        data_with_prediction = []
        for _, row in df.iterrows():
            item = {
                'date': int(row['date']),  # numpy int를 파이썬 int로 변환
                'height': float(row['height']),  # numpy float를 파이썬 float로 변환				
			}
            if has_fruit:
                item['fruitnum'] = float(row['fruitnum'])
            data_with_prediction.append(item)
            
        # 예측값 추가 (이미 파이썬 기본 타입으로 변환됨)
        pred_item = {
            'date': int(next_week),
            'height': float(round(pred_height, 2))
        }
        if has_fruit:
            pred_item['fruitnum'] = float(round(pred_fruit, 2))
        data_with_prediction.append(pred_item)

			
        results[plant_name] = data_with_prediction
        
    return results

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--csvDir", required=True)  # CSV 폴더 경로
    args = ap.parse_args()
    try:
        out = outdoor_json(args.csvDir)
        # ★ stdout에는 최종 JSON만!
        print(json.dumps(out, ensure_ascii=False))
    except Exception as e:
        # ★ 에러는 stderr로만!
        print(f"[PY-ERROR] {e}", file=sys.stderr)
        sys.exit(1)