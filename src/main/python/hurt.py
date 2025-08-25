import argparse, json, sys, os, traceback
import numpy as np
from PIL import Image
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import img_to_array

# === 모델/라벨/입력크기 매핑 (필요시 과일 추가) =========================
MODEL_INFO = {
    '딸기': {
        # 경로 확인
        'path': r'D:\disease\strawberry\strawberry_cnn_model.h5',
        'categories': ["잿빛곰팡이병", "정상", "흰가루병"],
        'input_size': (64, 64)
    },
    '귤': {
		'path': r'D:\disease\mandarin\mandarin_cnn_model.h5', 
		'categories': ["건강 잎", "잎 궤양", "잎 귤응애", "진딧물", "건강 열매", "열매 궤양"], 
		'input_size': (128,128)
	},
    '포도': {
		'path': r'D:\disease\grape\grape_cnn_model.h5', 
		'categories': ["탄저병", "축과병", "노균병", "정상", "일소 피해"], 
		'input_size': (128,128)
	},
    # '오렌지': {...},
    # '파프리카': {...},
}

def preprocess_image(image_file, target_size):
    img = Image.open(image_file).convert('RGB')
    img = img.resize(target_size)
    arr = img_to_array(img) / 255.0
    return np.expand_dims(arr, axis=0)

def main():
    parser = argparse.ArgumentParser(description='Plant disease predictor (CLI)')
    parser.add_argument('--fruit', required=True, help='과일명 (예: 딸기)')
    parser.add_argument('--image', required=True, help='이미지 파일 경로')
    args = parser.parse_args()

    fruit = args.fruit
    image_path = args.image

    # 입력 검증
    if fruit not in MODEL_INFO:
        print(json.dumps({'error': f'지원하지 않는 과일입니다: {fruit}'}, ensure_ascii=False))
        sys.exit(1)
    if not os.path.exists(image_path):
        print(json.dumps({'error': f'이미지 경로가 존재하지 않습니다: {image_path}'}, ensure_ascii=False))
        sys.exit(1)

    info = MODEL_INFO[fruit]
    try:
        # 1) 모델 로드
        model = load_model(info['path'])

        # 2) 전처리
        x = preprocess_image(image_path, info['input_size'])

        # 3) 추론
        pred = model.predict(x, verbose=0)  # shape: (1, N)
        idx = int(np.argmax(pred[0]))
        confidence = float(pred[0][idx])
        disease = info['categories'][idx]

        # 4) 결과 JSON 출력 (stdout)
        print(json.dumps({'disease': disease, 'confidence': confidence}, ensure_ascii=False))
        sys.exit(0)

    except Exception as e:
        # 스택트레이스는 디버깅용으로 stderr에
        traceback.print_exc(file=sys.stderr)
        print(json.dumps({'error': f'추론 실패: {e}'}, ensure_ascii=False))
        sys.exit(2)

if __name__ == '__main__':
    main()
