import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ilk_projem/widgets/custom_textfield.dart';

import 'home_navigator.dart';

class IlkHedefim extends StatelessWidget {
  String id;
  IlkHedefim(this.id);
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final dayController = TextEditingController();
  DateTime now = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final Firestore fireStore = Firestore.instance;
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            heroTag: "buton1",
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                if (isNumeric(priceController.text) == true) {
                  fireStore.collection("users").document(id).updateData({
                    "biriken": "0",
                    "hedef_adi": nameController.text,
                    "hedef_fiyati": priceController.text,
                    "startDate": now,
                    "targetDay": dayController.text,
                    "transitions": 0,
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeNavigator(id)));
                } else {
                  Fluttertoast.showToast(
                      msg: "Ücret sadece rakamlardan oluşmalıdır",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              }
            },
            label: Text("Başlayalım!"),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color(0xff09869a),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Text(
                      "Merhaba birikimci. Yeni hedefin için sana yardımcı olmak için buradayım. Hedefinin ismini ve tahmini tutarını girip hemen biriktirmeye başla!",
                      style: GoogleFonts.openSansCondensed(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    child: Image.asset("assets/newtargetbg.jpg"),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: MyTextFormField(
                          controller: nameController,
                          hintText: "Hedefinizin İsmi",
                          labelText: "Hedefinizin İsmi",
                          validator: (String val) {
                            if (val.isEmpty) {
                              return "Hedef ismi boş bırakılamaz*";
                            }
                            if (val.length < 3) {
                              return "En az 3 karakter kullanılmalı";
                            }
                            if (val.length > 10) {
                              return "En fazla 10 karakter kullanabilirsiniz";
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: MyTextFormField(
                          controller: priceController,
                          hintText: "Hedefinizin Tahmini Ücreti",
                          labelText: "Hedefinizin Tahmini Ücreti",
                          keyboardType: TextInputType.phone,
                          validator: (String val) {
                            if (isNumeric(val) == false) {
                              return "Sadece sayı giriniz*";
                            }
                            if (val.length > 7) {
                              return "Maksimum hedef ücretini aştınız!";
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: MyTextFormField(
                          controller: dayController,
                          hintText: "Hedefinizi Kaç Günde Tamamlayacaksınız?",
                          labelText: "Hedefinizi Kaç Günde Tamamlayacaksınız?",
                          keyboardType: TextInputType.phone,
                          validator: (String val) {
                            if (isNumeric(val) == false) {
                              return "Sadece sayı giriniz*";
                            }
                            if (val.length > 5) {
                              return "Maksimum gün sayısını aştınız!";
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
