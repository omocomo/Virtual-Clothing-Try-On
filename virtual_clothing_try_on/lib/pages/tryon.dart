import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:virtual_clothing_try_on/model/item.dart';
import 'package:virtual_clothing_try_on/model/user.dart';

class TryOnPage extends StatefulWidget {
  final int item_tag;
  final String gender, item_image, user_image;
  TryOnPage({required this.gender, required this.item_tag, required this.item_image, required this.user_image});

  @override
  State<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends State<TryOnPage> {
  @override
  void initState() {
    // super.initState();
    if (widget.item_tag == 2)
      PrintOriginal();
    else
      FaceSwapping();
  }

  bool _output_visibility = false;
  String outputName = '';
  var server = 'localhost'; // 0.0.0.0

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "output") {
        _output_visibility = visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "입어보기",
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
      body: (widget.item_tag == 0)
      ? SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "다양한 머리카락을 적용할 수 있는 이미지입니다.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.not_interested),
                    onPressed: () {
                      ChangeHair(0);
                    },
                  ),
                ),
                widget.gender == '여자'
                ? Expanded(
                  child: IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icon_hair1.png'),
                    onPressed: () {
                      ChangeHair(1);
                    },
                  ),
                )
                : Expanded(
                  child: IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icon_hair11.png'),
                    onPressed: () {
                      ChangeHair(11);
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icon_hair2.png'),
                    onPressed: () {
                      ChangeHair(2);
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icon_hair3.png'),
                    onPressed: () {
                      ChangeHair(3);
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icon_hair4.png'),
                    onPressed: () {
                      ChangeHair(4);
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icon_hair5.png'),
                    onPressed: () {
                      ChangeHair(5);
                    },
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.account_circle),
                    onPressed: () {
                      ChangeHair(-1);
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icon_hair6.png'),
                    onPressed: () {
                      ChangeHair(6);
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icon_hair7.png'),
                    onPressed: () {
                      ChangeHair(7);
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icon_hair8.png'),
                    onPressed: () {
                      ChangeHair(8);
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icon_hair9.png'),
                    onPressed: () {
                      ChangeHair(9);
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icon_hair10.png'),
                    onPressed: () {
                      ChangeHair(10);
                    },
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            _buildItemCard(context),
          ],
        ),
      )
      : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "머리카락을 적용할 수 없는 이미지입니다.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            _buildItemCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(context) {
    return Visibility(
      visible: _output_visibility,
      child: Card(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Image.network('http://localhost:8000/DATA/output/$outputName') // Image.asset(widget.info.image),
          ),
        ),
      ),
    );
  }

  Future FaceSwapping() async {
    _changed(false, "output");

    var dio = Dio();
    var formData = {
      'model_image': widget.item_image,
      'user_image': widget.user_image,
      'gender': widget.gender,
    };

    final response = await dio.post(
      'http://$server:8000/face_swapping',
      data: formData,
    );

    if (response.statusCode == 200) {
      outputName = response.data['outputName'];
      print(response.data['outputName']);
      _changed(true, "output");
    }
  }

  Future PrintOriginal() async {
    _changed(false, "output");

    var dio = Dio();
    var formData = {
      'model_image': widget.item_image,
      'gender': widget.gender,
    };

    final response = await dio.post(
      'http://$server:8000/print_original',
      data: formData,
    );

    if (response.statusCode == 200) {
      outputName = response.data['outputName'];
      print("찍혔나?" + response.data['outputName']);
      _changed(true, "output");
    }
  }

  Future ChangeHair(int hair_code) async {
    _changed(false, "output");

    // print(widget.info.image);
    // print(widget.user.image);

    var dio = Dio();
    var formData = {
      'model_image': widget.item_image,
      'user_image': widget.user_image,
      'hair_code': hair_code,
    };

    final response = await dio.post(
      'http://$server:8000/change_hair',
      data: formData,
    );

    if (response.statusCode == 200) {
      outputName = response.data['outputName'];
      print(response.data['outputName']);
      _changed(true, "output");
    }
  }
}
