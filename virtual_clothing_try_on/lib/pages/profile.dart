import 'package:flutter/material.dart';
import 'package:virtual_clothing_try_on/data/users.dart';

// final user = {
//   "username": "눈송이",
//   "email": "noonsong@sookmyung.ac.kr",
//   "password": "12345678",
//   "address": "서울특별시 용산구 청파동 숙명여대",
// };

class ProfilePage extends StatefulWidget {
  // final User user;
  // ProfilePage({required this.user});
  final int n;
  ProfilePage({required this.n});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "PROFILE",
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
              // SizedBox(
              //   height: 15,
              // ),
              // Text(
              //   "프로필 수정",
              //   style: TextStyle(
              //     fontSize: 25,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor
                        ),
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
                          image: AssetImage(users[widget.n]['image']),
                          fit: BoxFit.cover,
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
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      "저장",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 2.2,
                      ),
                    ),
                    onPressed: () {
                      print(_controller1.text);
                      users[widget.n]['username'] = _controller1.text;
                      users[widget.n]['email'] = _controller2.text;
                      users[widget.n]['password'] = _controller3.text;
                      users[widget.n]['address'] = _controller4.text;
                      Navigator.pop(context);
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

  late TextEditingController _controller1 = TextEditingController(text: users[widget.n]['username']);
  late TextEditingController _controller2 = TextEditingController(text: users[widget.n]['email']);
  late TextEditingController _controller3 = TextEditingController(text: users[widget.n]['password']);
  late TextEditingController _controller4 = TextEditingController(text: users[widget.n]['address']);
  Widget buildTextField(TextEditingController _controller, String labelText, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: _controller,
        obscureText: isPasswordTextField ? !showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField ? IconButton(
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
