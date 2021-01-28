import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ilk_projem/arayuz/login.dart';
import 'package:ilk_projem/services/kara-liste.dart';
import 'package:ilk_projem/widgets/custom_textfield.dart';
import 'package:ilk_projem/widgets/tobbar.dart';
import 'package:crypto/crypto.dart' as cyrpto;
import 'ilkHedefim.dart';

class Register extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<Register>
    with SingleTickerProviderStateMixin {
  bool passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  final myControllerPass = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerName = TextEditingController();
  final myControllerLastname = TextEditingController();
  final Firestore firestore = Firestore.instance;
  DateTime now = DateTime.now();
  void register() async {
    var bytes = utf8.encode(myControllerPass.text);
    var key = cyrpto.md5.convert(bytes);
    try {
      firestore.collection("users").document(myControllerEmail.text).setData({
        "email": myControllerEmail.text,
        "bitenHedefSayisi": "0",
        "name": myControllerName.text,
        "surname": myControllerLastname.text,
        "pass": key.toString(),
        "toplamBiriken": "0",
        "transitions": 0,
        "startDate": now,
        "targetDay": "0",
        "biriken": "0",
        "hedef_fiyati": "0",
        "hedef_adi": "",
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => IlkHedefim(myControllerEmail.text)));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        children: <Widget>[
          TopBar(),
          SizedBox(height: 30),
          _nameForm(),
          _lastNameForm(),
          _emailForm(),
          _passwordForm(),
          SizedBox(height: 30),
          _registerButton(size),
          SizedBox(height: 20),
          _routeRegisterWidget(context),
        ],
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
            "Hesabınız var mı ?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          FlatButton(
            child: Text(
              "Giriş",
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          )
        ],
      ),
    );
  }

  _registerButton(Size size) {
    KaraListe karaListe = KaraListe();
    bool isOkey = false;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.22),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.green,
        onPressed: () {
          for (int i = 0; i < karaListe.karaListe.length; i++) {
            if (karaListe.karaListe[i] == myControllerName.text ||
                karaListe.karaListe[i] == myControllerLastname.text ||
                karaListe.karaListe[i] == myControllerEmail.text) {
              isOkey = false;
            } else {
              isOkey = true;
            }
          }
          if (isOkey == true) {
            register();
          } else if (isOkey == false) {
            Fluttertoast.showToast(
                msg:
                    "Uygunsuz bir kelime girdiğiniz için üyelik işleminizi gerçekleştiremeyiz",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM_LEFT,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        child: Text(
          "Üye Ol",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  _emailForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: MyTextFormField(
        controller: myControllerEmail,
        labelText: "Email",
        hintText: 'Email',
        isEmail: true,
        validator: (String val) {
          if (val.isEmpty) {
            return "E Posta boş bırakılamaz*";
          }
          bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(val);
          if (!emailValid) {
            return "Geçersiz Format";
          }
        },
      ),
    );
  }

  _nameForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: MyTextFormField(
        controller: myControllerName,
        labelText: "İsim",
        hintText: 'İsim',
        isEmail: true,
        validator: (String val) {
          if (val.isEmpty) {
            return "Soyisim boş bırakılamaz*";
          }
        },
      ),
    );
  }

  _lastNameForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: MyTextFormField(
        controller: myControllerLastname,
        labelText: "Soy isim",
        hintText: 'Soy isim',
        isEmail: true,
        validator: (String val) {
          if (val.isEmpty) {
            return "Soyisim boş bırakılamaz*";
          }
        },
      ),
    );
  }

  _passwordForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: MyTextFormField(
        controller: myControllerPass,
        labelText: "Password",
        hintText: 'Password',
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
        validator: (String val) {
          if (val.isEmpty) {
            return "Şifre boş bırakılamaz*";
          }
          if (val.length < 7) {
            return "En az 7 karakter kullanılmalı";
          }
        },
      ),
    );
  }
}
