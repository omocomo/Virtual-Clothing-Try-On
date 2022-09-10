import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:virtual_clothing_try_on/model/item.dart';
import 'package:virtual_clothing_try_on/model/user.dart';

class TryOnPage extends StatefulWidget {
  final int item_tag;
  final String item_image, user_image;
  TryOnPage({required this.item_tag, required this.item_image, required this.user_image});

  @override
  State<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends State<TryOnPage> {
  @override
  void initState() {
    super.initState();
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
      ? Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Expanded(
                child: IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.not_interested),
                  onPressed: () {
                    ChangeHair(0);
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  iconSize: 50,
                  icon: Image.asset('assets/icon_hair2.png'),
                  onPressed: () {
                    ChangeHair(1);
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
                  icon: Image.asset('assets/icon_hair2.png'),
                  onPressed: () {
                    ChangeHair(3);
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  iconSize: 50,
                  icon: Image.asset('assets/icon_hair2.png'),
                  onPressed: () {
                    ChangeHair(4);
                  },
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          _buildItemCard(context),
        ],
      )
      : Column(
        children: [
          _buildItemCard(context),
        ],
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
