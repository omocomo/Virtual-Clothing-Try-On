# Flutter
### ํ์ผ ๊ตฌ์กฐ
```bash
๐ฆvirtual_clothing_try_on
 โฃ ๐lib
 โ โฃ ๐model
 โ โ โฃ ๐item.dart
 โ โ โ ๐user.dart
 โ โฃ ๐pages
 โ โ โฃ ๐detail.dart
 โ โ โฃ ๐home.dart
 โ โ โฃ ๐login.dart
 โ โ โฃ ๐profile.dart
 โ โ โฃ ๐signup.dart
 โ โ โ ๐tryon.dart
 โ โฃ ๐routes
 โ โ โ ๐request.dart
 โ โฃ ๐widgets
 โ โ โ ๐detail_image.dart
 โ โ ๐main.dart
 โฃ ๐assets
 โ ๐pubspec.yaml
 ```
- login.dart (๋ก๊ทธ์ธ ํ์ด์ง)    

 ![image](https://user-images.githubusercontent.com/39791467/198953551-88c607ef-746e-4176-927c-6aa248b1c8e7.png)

- signup.dart (ํ์๊ฐ์ ํ์ด์ง)    

 ![image](https://user-images.githubusercontent.com/39791467/198953509-62a3513c-4f4f-48b2-8d56-a0ad3f269a96.png)

- profile.dart (ํ๋กํ ์์  ํ์ด์ง)    

 ![image](https://user-images.githubusercontent.com/39791467/198954120-54cb9745-548e-4933-bb72-64a65e634527.png)

- home.dart (์ํ์ด ๋์ด๋๋ ํํ์ด์ง)    

 ![image](https://user-images.githubusercontent.com/39791467/198952434-22fc5990-81d8-47c4-ad92-7d21dc2f689e.png)
 
- detail.dart (์ํ์ ๋ํ ์์ธ์ ๋ณด ํ์ด์ง)    
  - widgets/detail_image.dart: ์ํ ์์ ฏ(์ํ ์ฌ์ง, ์์ด๋ณด๊ธฐ ๋ฒํผ, ์ํ ์ค๋ช)        
  
 ![image](https://user-images.githubusercontent.com/39791467/198953619-571585bb-174c-4539-b4e7-d38ea36ee487.png)

- tryon.dart (์์ด๋ณด๊ธฐ ์ ์ฉ ํ์ด์ง)    

![image](https://user-images.githubusercontent.com/39791467/198952652-4cd91ba9-ad0c-4d72-99f9-fa34fe4622e0.png)

- model    
  - item.dart: ์ํ class ๋ฐ json ๋ณํ ํจ์     
  - user.dart: ์ฌ์ฉ์ class ๋ฐ json ๋ณํ ํจ์    
- routes    
  - request.dart: FastAPI์ http ํต์ 
  
- assets ํด๋์ ์ด๋ฏธ์ง๋ [์ฌ๊ธฐ]()์์ ๋ค์ด๋ก๋ ๋ฐ์ ์ ์์ต๋๋ค.    
- pubspec.yaml: ํจํค์ง ์์กด์ฑ ๊ด๋ฆฌ ๋ฐ ํ๋ก์ ํธ ์ ์ ๋ฑ    

### ์คํ ๋ฐฉ๋ฒ
- main.dart ์คํ    
- ๊ธฐ๊ธฐ๋ฅผ ์ฐ๊ฒฐํ๊ณ  Run ํ๋ฉด build ํจ์์์ ์ฒซ ํ๋ฉด์ธ login ํ์ด์ง๊ฐ ๋ณด์๋๋ค.    
