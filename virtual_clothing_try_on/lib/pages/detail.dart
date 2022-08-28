import 'package:flutter/material.dart';
import 'package:virtual_clothing_try_on/data/items.dart';
import 'package:virtual_clothing_try_on/pages/tryon.dart';

class DetailPage extends StatelessWidget {
  final Item info;
  final int n;
  DetailPage({required this.info, required this.n});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "DETAIL",
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
      body: Stack(
        children: [
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black26
            ),
            child: Image.asset(
              info.image,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 250,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    info.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 16.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        info.star.toString() + "점/" + info.review.toString() + "리뷰",
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(32.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Color(0xffff3a5a)),
                                    Icon(Icons.star, color: Color(0xffff3a5a)),
                                    Icon(Icons.star, color: Color(0xffff3a5a)),
                                    Icon(Icons.star, color: Color(0xffff3a5a)),
                                    Icon(Icons.star_border, color: Color(0xffff3a5a)),
                                  ],
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 16.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      TextSpan(
                                        text: info.addition
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                info.price.toString(),
                                style: TextStyle(
                                  color: Color(0xffff3a5a),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                info.color.toString(),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30.0,
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
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TryOnPage(info: info, n: n)));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "상품 설명",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        info.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}