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

def process_one_csv(csv_path: Path):
    plant_name = csv_path.stem

    # CSV 로드
    try:
        df = pd.read_csv(csv_path, encoding="utf-8-sig", sep=None, engine="python")
    except Exception:
        df = pd.read_csv(csv_path, sep=None, engine="python")

    # 헤더 정규화
    df.columns = (df.columns.str.replace('\ufeff', '', regex=False).str.strip().str.lower())

    # 공통
    X = df[['date']].values
    y_height = df['height'].values

    svr_height = SVR(kernel='rbf', C=100, epsilon=0.1)
    svr_height.fit(X, y_height)

    next_week = X.max() + 1
    pred_height = float(svr_height.predict([[next_week]])[0])

    # fruitnum 있으면만
    has_fruit = 'fruitnum' in df.columns
    if has_fruit:
        y_fruitnum = df['fruitnum'].values
        svr_fruit = SVR(kernel='rbf', C=100, epsilon=0.1)
        svr_fruit.fit(X, y_fruitnum)
        pred_fruit = float(svr_fruit.predict([[next_week]])[0])
    else:
        pred_fruit = None

    # JSON 변환
    data_with_prediction = []
    for _, row in df.iterrows():
        item = {
            'date': int(row['date']),
            'height': float(row['height'])
        }
        if has_fruit:
            item['fruitnum'] = float(row['fruitnum'])
        data_with_prediction.append(item)

    pred_item = {'date': int(next_week), 'height': float(round(pred_height, 2))}
    if has_fruit:
        pred_item['fruitnum'] = float(round(pred_fruit, 2))
    data_with_prediction.append(pred_item)

    return plant_name, data_with_prediction
    
def outdoor_json(csv_dir, only_names=None):
    results = {}
    
    base = Path(csv_dir)
    
    if only_names:
        for name in only_names:
            f = base / f"{name}.csv"
            if not f.exists():
                print(f"{f.name} not found", file=sys.stderr)
                continue
            key, val = process_one_csv(f)
            results[key] = val
        
    return results

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--csvDir", required=True)  # CSV 폴더 경로
    # 콤마로 구분된 식물 이름 목록(파일명과 동일, 예: 방울토마토,오이)
    ap.add_argument("--only", default=None)
    args = ap.parse_args()
    try:
        only = None
        if args.only:
            only = {s.strip() for s in args.only.split(",") if s.strip()}
        out = outdoor_json(args.csvDir, only_names=only)
        # ★ stdout에는 최종 JSON만!
        print(json.dumps(out, ensure_ascii=False))
    except Exception as e:
        # ★ 에러는 stderr로만!
        print(f"[PY-ERROR] {e}", file=sys.stderr)
        sys.exit(1)