import 'package:flutter/material.dart';
import 'package:virtual_clothing_try_on/data/items.dart';

class TryOnPage extends StatefulWidget {
  final Item info;
  final int n;
  TryOnPage({required this.info, required this.n});

  @override
  State<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends State<TryOnPage> {
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
        Card(
          margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(widget.info.image),
            ),
          ),
        ),
      ],
    );
  }
}
