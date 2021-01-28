import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ilk_projem/arayuz/register.dart';
import 'package:ilk_projem/widgets/custom_textfield.dart';
import 'package:ilk_projem/widgets/tobbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_navigator.dart';
import 'package:crypto/crypto.dart' as cyrpto;
import 'ilkHedefim.dart';

class Login extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<Login> with SingleTickerProviderStateMixin {
  bool passwordVisible = true;
  String biriken, hedefFiyati;
  final Firestore firestore = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  final myControllerPass = TextEditingController();
  final myControllerId = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _guestLogin() async {
    DateTime now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int guestCount;
    DocumentSnapshot documentSnapshot;
    documentSnapshot =
        await firestore.collection("guestCount").document("guestCount").get();
    guestCount = documentSnapshot.data['guestCount'];
    firestore
        .collection("users")
        .document("Misafir ${guestCount + 1}")
        .setData({
      "bitenHedefSayisi": "0",
      "toplamBiriken": "0",
      "transitions": 0,
      "startDate": now,
      "targetDay": "0",
      "biriken": "0",
      "hedef_fiyati": "0",
      "hedef_adi": "",
    });
    firestore.collection("guestCount").document("guestCount").updateData({
      "guestCount": guestCount + 1,
    });
    prefs.setBool("flag", true);
    prefs.setString("docID", "Misafir ${guestCount + 1}");

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => IlkHedefim("Misafir ${guestCount + 1}")));
  }

  void _login() async {
    DocumentSnapshot documentSnapshot;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bytes = utf8.encode(myControllerPass.text);
    var key = cyrpto.md5.convert(bytes);
    try {
      documentSnapshot = await firestore
          .collection("users")
          .document(myControllerId.text)
          .get();
      biriken = documentSnapshot.data['biriken'];
      hedefFiyati = documentSnapshot.data['hedef_fiyati'];
      if (key.toString() == documentSnapshot.data['pass']) {
        prefs.setString("docID", myControllerId.text);
        prefs.setBool("flag", true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeNavigator(myControllerId.text),
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Email ya da şifreniz yanlış!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM_LEFT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  /////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        children: <Widget>[
          TopBar(),
          SizedBox(height: size.height * 0.1),
          _emailForm(),
          _passwordForm(),
          SizedBox(height: 30),
          _loginButton(size),
          SizedBox(height: 20),
          _guestLoginButton(size),
          SizedBox(height: 20),
          _routeRegisterWidget(context),
          _forgetPassword(context),
          //SizedBox(height: 20),
          //_socialLogin(),
        ],
      ),
    );
  }

  dialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(),
    );
  }

  contentBox() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: Constants.padding,
            top: Constants.avatarRadius + Constants.padding,
            right: Constants.padding,
            //  bottom: Constants.padding,
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  "Misafir olarak girdiğin için çıkış yaparsan veya uygulamayı silersen tüm verilerinin silineceğini unutma!"),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: () {
                      _guestLogin();
                    },
                    child: Text(
                      "Tamamdır",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ), // bottom part
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/box.png")),
          ),
        ) // top part
      ],
    );
  }

  _guestLoginButton(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.22),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.green,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return dialog();
              });
        },
        child: Text(
          "Misafir Olarak Devam Et",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  _routeRegisterWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 42, left: 42, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Hesabınız yok mu?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          FlatButton(
            child: Text(
              "Üye Ol",
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Register(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  _forgetPassword(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 42, left: 42, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text(
              "Şifremi Unuttum",
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  _loginButton(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.22),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.green,
        onPressed: () {
          // if (myControllerPass.text.length < 7) {
          //   Fluttertoast.showToast(
          //       msg: "Şifreniz 7 haneden küçük olamaz",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.BOTTOM_LEFT,
          //       timeInSecForIosWeb: 1,
          //       backgroundColor: Colors.black,
          //       textColor: Colors.white,
          //       fontSize: 16.0);
          // }
          _login();
        },
        child: Text(
          "Giriş Yap",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  _emailForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: MyTextFormField(
        controller: myControllerId,
        labelText: "Email",
        hintText: 'Email',
        isEmail: true,
      ),
    );
  }

  _passwordForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: MyTextFormField(
        controller: myControllerPass,
        labelText: "Şifre",
        hintText: 'Şifre',
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),
        isPassword: passwordVisible,
        validator: (String value) {
          if (value.length < 7) {
            return 'Password should be minimum 7 characters';
          }

          _formKey.currentState.save();

          return null;
        },
      ),
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
