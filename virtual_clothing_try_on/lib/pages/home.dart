import 'package:flutter/material.dart';
import 'package:virtual_clothing_try_on/pages/login.dart';
import 'package:virtual_clothing_try_on/pages/profile.dart';
import 'package:virtual_clothing_try_on/pages/detail.dart';
import 'package:virtual_clothing_try_on/data/items.dart';
import 'package:virtual_clothing_try_on/data/users.dart';

class HomePage extends StatelessWidget {
  // final User user;
  // HomePage({required this.user});
  final int n;
  HomePage({required this.n});

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
              onPressed: (){
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(n: n)));
                },
              ),
            ],
            floating: true,
            flexibleSpace: ListView(
              children: <Widget>[
                SizedBox(height: 70.0,),
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
                        onPressed: (){},
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _buildItems(context, index);
                },
              childCount: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItems(BuildContext context, int index) {
    var item = items[index % items.length];
    Item info = Item(item['id'], item['star'], item['review'], item['price'], item['image'], item['title'], item['color'], item['addition'], item['description']);
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
                    Image.asset(item['image']),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.black,
                          size: 24.0,
                        ),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(info: info, n: n)));
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 20.0,
                      right: 10.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        color: Colors.white,
                        child: Text(info.price.toString()),
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
                        item['title'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        item['addition'],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // item['review'] 숫자에 따라 별점 다르게 표시해야 함
                          Icon(Icons.star, color: Color(0xffff3a5a),),
                          Icon(Icons.star, color: Color(0xffff3a5a),),
                          Icon(Icons.star, color: Color(0xffff3a5a),),
                          Icon(Icons.star, color: Color(0xffff3a5a),),
                          Icon(Icons.star_border, color: Color(0xffff3a5a),),
                          SizedBox(width: 5.0,),
                          Text(
                            "(" + item['review'].toString() + " reviews)",
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