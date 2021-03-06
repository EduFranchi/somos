import 'package:flutter/material.dart';
import 'package:somos/view/UserList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserList(),
      debugShowCheckedModeBanner: false,
    );
  }
}
