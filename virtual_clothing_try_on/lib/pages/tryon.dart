import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:virtual_clothing_try_on/model/item.dart';
import 'package:virtual_clothing_try_on/model/user.dart';

class TryOnPage extends StatefulWidget {
  final Item info;
  final User user;
  TryOnPage({required this.info, required this.user});

  @override
  State<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends State<TryOnPage> {
  @override
  void initState() {
    super.initState();
    GetTryOn();
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
      body: _buildItemCard(context),
    );
  }

  Widget _buildItemCard(context) {
    return Stack(
      children: <Widget>[
        Visibility(
          visible: _output_visibility,
          child:
            Card(
              margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.network('http://$server:8000/DATA/output/$outputName') // Image.asset(widget.info.image),
                ),
              ),
            ),
        )
      ],
    );
  }

  Future GetTryOn() async {
    _changed(false, "output");

    // print(widget.info.image);
    // print(widget.user.image);

    var dio = Dio();
    var formData = {
      'model_image': widget.info.image.toString(),
      'user_image': widget.user.image.toString(),
    };


    final response =
      await dio.post('http://$server:8000/get_tryon',
        data: formData,
    );

    if (response.statusCode == 200) {
      outputName = response.data['outputName'];
      print(response.data['outputName']);
      _changed(true, "output");
    }

  }
}
