import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_navigator.dart';
import 'login.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  String id;
  bool flag;
  bool isFirstTime;
  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      flag = prefs.getBool("flag");
      id = prefs.getString("docID");
      isFirstTime = prefs.getBool("isFirstTime");
      if (flag == true) {
        Timer(
            Duration(seconds: 2),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomeNavigator(id))));
      } else {
        if (isFirstTime != false) {
          Timer(
              Duration(seconds: 2),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => OnboardingScreen())));
        } else {
          Timer(
              Duration(seconds: 2),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Login())));
        }
      }
    });
  }

  @override
  void initState() {
    autoLogin();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //width: MediaQuery.of(context).size.width,
          child: Image.asset('assets/icon.png'),
        ),
      ),
    );
  }
}
