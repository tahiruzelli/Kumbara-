import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:ilk_projem/arayuz/splashScreen.dart';
void main() {
  //FirebaseAdMob.instance.initialize(appId: "ca-app-pub-5871102290640680~3044089832");
  runApp(MyKumbara());
}

class MyKumbara extends StatefulWidget {
  @override
  _MyKumbara createState() => _MyKumbara();
}

class _MyKumbara extends State<MyKumbara> {

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
