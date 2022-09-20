import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_clothing_try_on/model/item.dart';
import 'package:virtual_clothing_try_on/model/user.dart';
import 'package:virtual_clothing_try_on/pages/login.dart';
import 'package:virtual_clothing_try_on/pages/profile.dart';
import 'package:virtual_clothing_try_on/pages/detail.dart';

class HomePage extends StatelessWidget {
  // final User user;
  // HomePage({required this.user});
  final User user;
  HomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 180.0,
            backgroundColor: Color(0xffff3a5a),
            leading: IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                // set up the button
                Widget okButton = TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                );

                AlertDialog alert = AlertDialog(
                  title: Text("로그아웃"),
                  content: Text("로그아웃 하시겠습니까?"),
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
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfilePage(user: user)));
                },
              ),
            ],
            floating: true,
            flexibleSpace: ListView(
              children: <Widget>[
                SizedBox(
                  height: 70.0,
                ),
                Text(
                  "Soodo Shop",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "편안하고 멋스러운 포멀룩",
                      border: InputBorder.none,
                      icon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10.0,
            ),
          ),
          StreamBuilder<List<Item>>(
              stream: user.gender == '남자'
                  ? readItems('man_items')
                  : readItems('woman_items'),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Text('Something went wrong!'),
                  );
                } else if (snapshot.hasData) {
                  final items = snapshot.data!;
                  return SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                    return _buildItems(context, items[index]);
                  }, childCount: items.length));
                } else {
                  return SliverToBoxAdapter(
                    child: Text('No Data'),
                  );
                }
              }),
        ],
      ),
    );
  }

  Stream<List<Item>> readItems(String gender_items) =>
      FirebaseFirestore.instance.collection(gender_items).snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList());

  Widget _buildItems(BuildContext context, Item item) {
    int item_star = (item.star - 1) % 5;
    print(item.star);
    print("별점: " + (item.star % 5).toString());

    return Container(
      margin: EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.network(
                        'http://localhost:8000/${item.image[0]}?v=${DateTime.now().millisecondsSinceEpoch}'),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.black,
                          size: 24.0,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(info: item, user: user)));
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 20.0,
                      right: 10.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        color: Colors.white,
                        child: Text(item.price.toString()),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        item.addition,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // item['review'] 숫자에 따라 별점 다르게 표시해야 함
                          item_star >= 0
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffff3a5a),
                                )
                              : Icon(
                                  Icons.star_border,
                                  color: Color(0xffff3a5a),
                                ),
                          item_star >= 1
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffff3a5a),
                                )
                              : Icon(
                                  Icons.star_border,
                                  color: Color(0xffff3a5a),
                                ),
                          item_star >= 2
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffff3a5a),
                                )
                              : Icon(
                                  Icons.star_border,
                                  color: Color(0xffff3a5a),
                                ),
                          item_star >= 3
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffff3a5a),
                                )
                              : Icon(
                                  Icons.star_border,
                                  color: Color(0xffff3a5a),
                                ),
                          item_star >= 4
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffff3a5a),
                                )
                              : Icon(
                                  Icons.star_border,
                                  color: Color(0xffff3a5a),
                                ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "(" + item.review.toString() + " reviews)",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
