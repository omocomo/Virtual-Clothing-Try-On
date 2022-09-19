import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_clothing_try_on/model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtual_clothing_try_on/routes/request.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
// class User {
//   String id = '';
//   String image, username, email, password, address;
//
//   User({
//     this.id = '',
//     required this.image,
//     required this.username,
//     required this.email,
//     required this.password,
//     required this.address,
//   });

class _SignUpPageState extends State<SignUpPage> {
  XFile? pickedFile;
  String _gender = '남자';
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "회원가입",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color(0xffff3a5a),
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 0, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: Stack(
                  children: [
                    (pickedFile == null)
                        ? Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10),
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/user_default.png"),
                              ),
                            ),
                          )
                        : Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10),
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(pickedFile!.path)),
                                // image: (pickedFile != null)
                                //     ? FileImage(File(pickedFile!.path))
                                //     : AssetImage("assets/user_default.png"),
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Color(0xffff3a5a),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 17,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            AlertDialog alert = AlertDialog(
                              title: const Text('프로필 사진 선택'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('사진은 정면으로 머리카락이 잘 정돈\n된 상태가 좋습니다.'),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _getFromCamera();
                                    },
                                    child: Row(children: const [
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.camera,
                                          // color: Colors.purple
                                        ),
                                      ),
                                      Text(
                                        'Camera',
                                        // style: TextStyle(color:Colors.purple),
                                      )
                                    ]),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _getFromGallery();
                                    },
                                    child: Row(children: const [
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.image,
                                          // color: Colors.purple
                                        ),
                                      ),
                                      Text(
                                        'Gallery',
                                        // style: TextStyle(color:Colors.purple),
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                            );
                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 35.0),
                      child: RadioListTile(
                        title: Text(
                          '남자',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        value: '남자',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 35.0),
                      child: RadioListTile(
                        title: Text('여자'),
                        value: '여자',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              buildTextField(_controller1, "이름", false),
              buildTextField(_controller2, "이메일", false),
              buildTextField(_controller3, "비밀번호", true),
              buildTextField(_controller4, "주소", false),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black12,
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      "취소",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        letterSpacing: 2.2,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xffff3a5a),
                      elevation: 2,
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text(
                      "가입",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 2.2,
                      ),
                    ),
                    onPressed: () async {
                      if (pickedFile == null) {
                        // 이미지 null일 경우
                        Widget okButton = TextButton(
                          child: Text("확인"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        );

                        AlertDialog alert = AlertDialog(
                          title: Text("회원가입 실패"),
                          content: Text("사진을 필수로 입력해야 합니다."),
                          actions: [
                            okButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      } else if (_controller1.text == "") {
                        // 유저네임
                        Widget okButton = TextButton(
                          child: Text("확인"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        );

                        AlertDialog alert = AlertDialog(
                          title: Text("회원가입 실패"),
                          content: Text("이름을 입력하지 않았습니다."),
                          actions: [
                            okButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      } else if (_controller2.text == "") {
                        // 이메일
                        Widget okButton = TextButton(
                          child: Text("확인"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        );

                        AlertDialog alert = AlertDialog(
                          title: Text("회원가입 실패"),
                          content: Text("이메일을 입력하지 않았습니다."),
                          actions: [
                            okButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      } else if (_controller3.text == "") {
                        // 패스워드
                        Widget okButton = TextButton(
                          child: Text("확인"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        );

                        AlertDialog alert = AlertDialog(
                          title: Text("회원가입 실패"),
                          content: Text("비밀번호를 입력하지 않았습니다."),
                          actions: [
                            okButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      } else if (_controller4.text == "") {
                        // 주소
                        Widget okButton = TextButton(
                          child: Text("확인"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        );

                        AlertDialog alert = AlertDialog(
                          title: Text("회원가입 실패"),
                          content: Text("주소를 입력하지 않았습니다."),
                          actions: [
                            okButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      } else {
                        User user = User(
                            image: "",
                            gender: _gender,
                            username: _controller1.text,
                            email: _controller2.text,
                            password: _controller3.text,
                            address: _controller4.text);
                        createUser(user);
                        await uploadUserImage(pickedFile!, user.image);
                        // set up the button
                        Widget okButton = TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pop(context);
                          },
                        );

                        AlertDialog alert = AlertDialog(
                          title: Text("회원가입 성공"),
                          content: Text("이제부터 sudo shop을 이용하실 수 있습니다."),
                          actions: [
                            okButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createUser(User user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;
    user.image = "DATA/user/${docUser.id}.jpg";

    final json = user.toJson();
    await docUser.set(json);
  }

  void _getFromCamera() async {
    XFile? tmp = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      pickedFile = tmp;
    });

    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? tmp = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      pickedFile = tmp;
    });

    Navigator.pop(context);
  }

  late TextEditingController _controller1 = TextEditingController();
  late TextEditingController _controller2 = TextEditingController();
  late TextEditingController _controller3 = TextEditingController();
  late TextEditingController _controller4 = TextEditingController();
  Widget buildTextField(TextEditingController _controller, String labelText,
      bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: _controller,
        obscureText: isPasswordTextField ? !showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // hintText: placeholder,
          // hintStyle: TextStyle(
          //   color: Colors.grey,
          //   fontSize: 16,
          //   fontWeight: FontWeight.bold,
          // ),
        ),
      ),
    );
  }
}
