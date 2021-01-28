import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ilk_projem/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart' as cyrpto;
import 'ilkHedefim.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  String id;
  Profile(this.id);
  @override
  _Profile createState() => _Profile();
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class _Profile extends State<Profile> {
  bool passwordVisible;
  DocumentSnapshot documentSnapshot;
  Map datas;
  DateTime now = DateTime.now();
  Timestamp t;
  final Firestore fireStore = Firestore.instance;
  final field1 = TextEditingController();
  final field2 = TextEditingController();
  bool hataliMi = false;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void getDatas() async {
    double biriken;
    int gecenSure;
    try {
      documentSnapshot =
          await fireStore.collection("users").document(widget.id).get();
      setState(() {
        datas = documentSnapshot.data;
        try {
          t = datas['startDate'];
          gecenSure = now.day - t.toDate().day;
          /*----------------------------------------*/
          if (gecenSure == 0) {
            gecenSure = 1;
          }
          if (datas['hedef_fiyati'] == "0") {
            datas['hedef_fiyati'] = "1";
          }
          biriken = 100 *
              int.parse(datas['biriken']) /
              int.parse(datas['hedef_fiyati']);

          datas['puan'] = (((int.parse(datas['targetDay']) / gecenSure) * 0.4 +
                      ((biriken) * 0.6)) /
                  10) +
              int.parse(datas['bitenHedefSayisi']);
        } catch (e) {
          hataliMi = true;
          print(e);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getDatas();
    super.initState();
  }

  bool isAllSelect = true;
  @override
  Widget build(BuildContext context) {
    List<UnicornButton> childButtons = [
      UnicornButton(
        hasLabel: true,
        labelText: "Şifremi Değiştir",
        labelFontSize: 20,
        currentButton: FloatingActionButton(
          backgroundColor: Colors.black45,
          mini: true,
          heroTag: "Şifremi Değiştir",
          child: Icon(Icons.lock_outline),
          onPressed: () {
            field1.text = "";
            field2.text = "";
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return dialog(
                      "Eskisinden daha güçlü bir şifre olsun",
                      false,
                      "Eski şifren",
                      "Yeni şifren",
                      TextInputType.visiblePassword);
                });
          },
        ),
      ),
      UnicornButton(
        labelText: "Yeni Hedef Oluştur",
        hasLabel: true,
        labelFontSize: 20,
        currentButton: FloatingActionButton(
            heroTag: "Hedef Ekle",
            backgroundColor: Colors.blueGrey,
            mini: true,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IlkHedefim(widget.id)));
            }),
      ),
      UnicornButton(
        labelText: "Hedefimin Fiyatını Güncelle",
        hasLabel: true,
        labelFontSize: 20,
        currentButton: FloatingActionButton(
            heroTag: "Hedef Fiyatını Güncelle",
            backgroundColor: Colors.lightGreen,
            mini: true,
            child: Icon(Icons.replay_circle_filled),
            onPressed: () {
              field1.text = "";
              field2.text = "";
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialog(
                        "Hedefini en iyi şekilde planla",
                        true,
                        "Ne için para biriktireceksin?",
                        "Ne kadar para biriktireceksin?",
                        TextInputType.number);
                  });
            }),
      ),
      UnicornButton(
        labelText: "Çıkış Yap",
        hasLabel: true,
        labelFontSize: 20,
        currentButton: FloatingActionButton(
          heroTag: "cikisYap",
          backgroundColor: Colors.red,
          mini: true,
          child: Icon(Icons.exit_to_app),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
        ),
      ),
    ];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: UnicornDialer(
        backgroundColor: Colors.black45,
        parentButtonBackground: Colors.black,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.settings),
        childButtons: childButtons,
      ),
      body: documentSnapshot == null
          ? Container(
              height: height,
              width: width,
              color: Color(0xFFffffff),
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.1),
                child: Center(
                  child:
                      Image.asset("assets/loading.gif", fit: BoxFit.fitWidth),
                ),
              ),
            )
          : Column(
              children: [
                //bilgiler
                Row(
                  children: [
                    Icon(
                      Icons.person_outlined,
                      size: MediaQuery.of(context).size.width * 0.3,
                      color: Color(0xFF5D6A78),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        documentSnapshot.data['name'] == null
                            ? Text("")
                            : Text(
                                " ${documentSnapshot.data['name']} ${documentSnapshot.data['surname']}"
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5D6A78)),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 40,
                                color: Colors.green,
                              ),
                              SizedBox(width: 5),
                              Text("  Birikimci",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFF5D6A78))),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: height * 0.05),
                Container(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            hataliMi
                                ? "Hatalı"
                                : "${datas["puan"].toStringAsFixed(2)}",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                                color: Color(0xFF5D6A78)),
                          ),
                          Text("Utanç Puanı",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF5D6A78))),
                        ],
                      ),
                      Container(width: 3, height: 30, color: Colors.green),
                      Column(
                        children: [
                          Text("${datas["bitenHedefSayisi"]}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Color(0xFF5D6A78))),
                          Text("Tamamlanan Hedef",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF5D6A78))),
                        ],
                      ),
                      Container(width: 3, height: 30, color: Colors.green),
                      Column(
                        children: [
                          Text("${datas['toplamBiriken']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Color(0xFF5D6A78))),
                          Text("Toplam Biriktirilen",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF5D6A78))),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.025),
                Container(
                  width: width * 0.9,
                  height: 2,
                  color: Colors.green,
                ),
                Expanded(
                    child: Image.asset(
                  "assets/profilebg.gif",
                  fit: BoxFit.fill,
                ))
              ],
            ),
    );
  }

  dialog(String title, bool durum, String fieldText1, String fieldText2,
      TextInputType inputType) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child:
          contentBox(context, durum, title, fieldText1, fieldText2, inputType),
    );
  }

  contentBox(context, bool durum, String title, String fieldText1,
      String fieldText2, TextInputType inputType) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
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
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              MyTextFormField(
                isPassword: !durum,
                controller: field1,
                hintText: fieldText1,
                labelText: fieldText1,
                keyboardType: TextInputType.name,
              ),
              SizedBox(
                height: 22,
              ),
              MyTextFormField(
                isPassword: !durum,
                controller: field2,
                hintText: fieldText2,
                labelText: fieldText2,
                keyboardType: inputType,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: () async {
                      if (durum == false) {
                        var bytes = utf8.encode(field1.text);
                        var key = cyrpto.md5.convert(bytes);
                        if (datas["pass"] == key.toString()) {
                          var bytes = utf8.encode(field2.text);
                          var key = cyrpto.md5.convert(bytes);
                          fireStore
                              .collection("users")
                              .document(widget.id)
                              .updateData({
                            "pass": key.toString(),
                          });
                          Navigator.of(context).pop();
                        } else {
                          Fluttertoast.showToast(
                              msg: "Eski şifrenizi yanlış girdiniz",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } //şifre

                      if (durum == true) {
                        if (field1.text.length < 10) {
                          if (isNumeric(field2.text)) {
                            if (field2.text.length < 7) {
                              fireStore
                                  .collection("users")
                                  .document(widget.id)
                                  .updateData({
                                "biriken": "0",
                                "hedef_adi": field1.text,
                                "hedef_fiyati": field2.text,
                                "startDate": now,
                                "transitions": 0,
                              });
                              Navigator.of(context).pop();
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Hedef fiyatı en fazla 7 haneden olabilir!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM_LEFT,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Hedef fiyatı sadece sayılardan oluşmalı!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM_LEFT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Hedef ismi 10 karakterden uzun!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM_LEFT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } //yeni hedef
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
}
