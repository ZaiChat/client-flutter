import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZaiChat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ZaiChatHomePage(),
    );
  }
}

class ZaiChatHomePage extends StatelessWidget {
  ZaiChatHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ZaiChat"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'There are going to be messages here',
            ),
          ],
        ),
      ),
    );
  }
}
