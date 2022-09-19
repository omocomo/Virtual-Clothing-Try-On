import 'package:dio/dio.dart';

var server = 'localhost'; // server 0.0.0.0

Future<String> uploadUserImage(pickedFile, user_image_name) async {
  if (pickedFile != null) {
    var image_file = pickedFile.path;
    // var image_name = pickedFile.name;
    // var uploadfile = pickedFile.bytes;

    // 파일 경로를 통해 formData 생성
    var dio = Dio();
    var formData = FormData.fromMap({
      'in_files':
          MultipartFile.fromFileSync(image_file, filename: user_image_name)
    });

    // 업로드 요청
    final response = await dio.post('http://localhost:8000/user_image_upload',
        data: formData);

    if (response.statusCode == 200) {
      var select_image_path = response.data['imgUrl'];
      print(response.data['imgUrl']);
      return response.data['imgUrl'];
    }
  }
  return 'None';
}
