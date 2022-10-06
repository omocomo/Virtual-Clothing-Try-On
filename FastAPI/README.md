# FastAPI
### 파일 구조
```bash
📦FastAPI
 ┣ 📂DATA
 ┃ ┣ 📂hair
 ┃ ┣ 📂model
 ┃ ┣ 📂output
 ┃ ┗ 📂user
 ┣ 📂HairSegmentation
 ┣ 📂routes
 ┃ ┗ 📜tryon.py
 ┗ 📂SimSwap
 ```
 - DATA 폴더의 이미지는 [여기]()에서 다운로드 받을 수 있습니다.
 - routes 폴더 안의 `tryon.py`에 주요 기능들이 구현되어 있습니다.

### 실행 방법
```
conda activate tryon
cd FastAPI
uvicorn index:app --reload --host=0.0.0.0 
```
- `--reload`는 코드 수정 시 바로 반영되기 위함
- `--host=0.0.0.0`은 Flutter 앱 실행을 위해 다른 호스트에서도 접근 가능하게 하기 위함
