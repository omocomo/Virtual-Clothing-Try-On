import 'package:flutter/material.dart';
import 'package:virtual_clothing_try_on/model/item.dart';
import 'package:virtual_clothing_try_on/model/user.dart';
import 'package:virtual_clothing_try_on/pages/tryon.dart';

class DetailImage extends StatelessWidget {
  final String user_image, gender;
  final String item_image, item_description;
  final int item_tag;

  DetailImage(
      {required this.gender,
      required this.user_image,
      required this.item_image,
      required this.item_description,
      required this.item_tag});

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
        (item_tag != 2)
            ? SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff333333),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                  ),
                  child: Text(
                    "입어보기",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TryOnPage(
                            gender: gender,
                            item_tag: item_tag,
                            item_image: item_image,
                            user_image: user_image)));
                  },
                ),
              )
            : SizedBox(),
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
