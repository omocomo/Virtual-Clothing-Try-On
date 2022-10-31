# Flutter
### 파일 구조
```bash
📦virtual_clothing_try_on
 ┣ 📂lib
 ┃ ┣ 📂model
 ┃ ┃ ┣ 📜item.dart
 ┃ ┃ ┗ 📜user.dart
 ┃ ┣ 📂pages
 ┃ ┃ ┣ 📜detail.dart
 ┃ ┃ ┣ 📜home.dart
 ┃ ┃ ┣ 📜login.dart
 ┃ ┃ ┣ 📜profile.dart
 ┃ ┃ ┣ 📜signup.dart
 ┃ ┃ ┗ 📜tryon.dart
 ┃ ┣ 📂routes
 ┃ ┃ ┗ 📜request.dart
 ┃ ┣ 📂widgets
 ┃ ┃ ┗ 📜detail_image.dart
 ┃ ┗ 📜main.dart
 ┣ 📂assets
 ┗ 📜pubspec.yaml
 ```
- login.dart (로그인 페이지)    

 ![image](https://user-images.githubusercontent.com/39791467/198953551-88c607ef-746e-4176-927c-6aa248b1c8e7.png)

- signup.dart (회원가입 페이지)    

 ![image](https://user-images.githubusercontent.com/39791467/198953509-62a3513c-4f4f-48b2-8d56-a0ad3f269a96.png)

- profile.dart (프로필 수정 페이지)    

 ![image](https://user-images.githubusercontent.com/39791467/198954120-54cb9745-548e-4933-bb72-64a65e634527.png)

- home.dart (상품이 나열되는 홈페이지)    

 ![image](https://user-images.githubusercontent.com/39791467/198952434-22fc5990-81d8-47c4-ad92-7d21dc2f689e.png)
 
- detail.dart (상품에 대한 상세정보 페이지)    
  - widgets/detail_image.dart: 상품 위젯(상품 사진, 입어보기 버튼, 상품 설명)        
  
 ![image](https://user-images.githubusercontent.com/39791467/198953619-571585bb-174c-4539-b4e7-d38ea36ee487.png)

- tryon.dart (입어보기 적용 페이지)    

![image](https://user-images.githubusercontent.com/39791467/198952652-4cd91ba9-ad0c-4d72-99f9-fa34fe4622e0.png)

- model    
  - item.dart: 상품 class 및 json 변환 함수     
  - user.dart: 사용자 class 및 json 변환 함수    
- routes    
  - request.dart: FastAPI와 http 통신
  
- assets 폴더의 이미지는 [여기]()에서 다운로드 받을 수 있습니다.    
- pubspec.yaml: 패키지 의존성 관리 및 프로젝트 정의 등    

### 실행 방법
- main.dart 실행    
- 기기를 연결하고 Run 하면 build 함수에서 첫 화면인 login 페이지가 보입니다.    
