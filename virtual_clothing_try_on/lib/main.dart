import 'package:flutter/material.dart';
import 'package:virtual_clothing_try_on/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 디버그 배너 제거
      debugShowCheckedModeBanner: false,
      title: 'Soodo Shop',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginPage(),
    );
  }
}