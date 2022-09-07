import 'package:flutter/material.dart';
import 'package:virtual_clothing_try_on/model/item.dart';
import 'package:virtual_clothing_try_on/model/user.dart';
import 'package:virtual_clothing_try_on/pages/tryon.dart';

class DetailImage extends StatelessWidget {
  final String user_image;
  final String item_image, item_description;
  final int item_tag;

  DetailImage({required this.user_image, required this.item_image, required this.item_description, required this.item_tag});

  @override
  Widget build(BuildContext context) {
    print("출력해보자: " + user_image);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(
          'http://localhost:8000/${item_image}',
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              primary: Color(0xffff3a5a),
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            ),
            child: Text(
              "입어보기",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TryOnPage(item_image: item_image, user_image: user_image)));
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          item_description,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
