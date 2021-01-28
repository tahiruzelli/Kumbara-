import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ilk_projem/services/advert-service.dart';
import 'package:ilk_projem/widgets/custom_textfield.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'hedefBitti.dart';

class MyHomePage extends StatefulWidget {
  String id;
  // String biriken;
  // String hedefFiyati;
  // MyHomePage(this.id, this.biriken, this.hedefFiyati);
  MyHomePage(this.id);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime now = DateTime.now();
  AudioCache player = AudioCache();
  var trans;
  Map datas;
  String name;
  String surname;
  var degisken;
  int counter = 0;
  DocumentSnapshot documentSnapshot;
  final eklemeTutari = TextEditingController();
  final Firestore firestore = Firestore.instance;
  final AdvertService _advertService = AdvertService();
  final _formKey = GlobalKey<FormState>();
  String priceInChart;
  bool bugFixer;

  void _login() async {
    try {
      documentSnapshot =
          await firestore.collection("users").document(widget.id).get();
      setState(() {
        datas = documentSnapshot.data;
      });
    } catch (e) {
      print(e);
    }
    priceInChart = "${datas['biriken']}₺ / ${datas['hedef_fiyati']}₺";
    if (datas['hedef_fiyati'] == "0") {
      bugFixer = true;
    } else {
      bugFixer = false;
    }
  }

  void playAudio(bool durum) {
    if (durum == false) {
      if (double.parse(eklemeTutari.text) < 15 &&
          double.parse(eklemeTutari.text) > 0) {
        player.play("paraEkleAz.mp3");
      } else if (double.parse(eklemeTutari.text) < 50 &&
          double.parse(eklemeTutari.text) >= 15) {
        player.play("paraEkleOrta.mp3");
      } else if (double.parse(eklemeTutari.text) >= 50) {
        player.play("paraEkleCok.mp3");
      }
    } else {
      player.play("paraCikar.mp3");
    }
  }

  void getTransition() async {
    DocumentSnapshot documentSnapshot;
    counter = 0;
    try {
      documentSnapshot =
          await firestore.collection("users").document(widget.id).get();

      setState(() {
        trans = documentSnapshot.data['transitions'];
        name = documentSnapshot['name'];
        surname = documentSnapshot['surname'];
      });
      for (var item in documentSnapshot.data['transitions']) {
        counter++;
      }
    } catch (e) {
      print(e);
    }
  }

  void remove(bool durum, int deger) async {
    DateTime todaysDate = DateTime.now();
    setState(() {
      firestore.collection("users").document(widget.id).updateData({
        "transitions": FieldValue.arrayUnion([
          {
            "date": "${now.day} ${now.month} ${now.year}",
            "price": "${durum ? deger * -1 : deger}",
            "cakmaID":
                "${todaysDate.day}-${todaysDate.month}-${todaysDate.year}-${todaysDate.minute}-${todaysDate.second}-${todaysDate.millisecond}",
          }
        ])
      });

      try {
        datas["biriken"] = durum
            ? (int.parse(datas["biriken"]) - deger).toString()
            : (int.parse(datas["biriken"]) + deger).toString();
        firestore.collection('users').document(widget.id).updateData({
          'biriken': datas["biriken"],
          "toplamBiriken": (double.parse(datas["toplamBiriken"]) +
                  double.parse(datas["biriken"]))
              .toString(),
        });
      } catch (e) {
        print(e);
      }
      getTransition();
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  void initState() {
    // _advertService.showBanner();
    getTransition();
    _login();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Scaffold(
        body: datas == null
            ? Container(
                height: s.height,
                width: s.width,
                color: Color(0xFFffffff),
                child: Padding(
                  padding: EdgeInsets.only(bottom: s.height * 0.1),
                  child: Center(
                    child:
                        Image.asset("assets/loading.gif", fit: BoxFit.fitWidth),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        datas['hedef_adi'],
                        style: GoogleFonts.poppins(
                            fontSize: 30, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 20),
                      chart(),
                    ],
                  ),
                  buttons(),
                  transitions(),
                ],
              ),
      ),
    );
  }

  transitions() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.grey[200],
            ),
            height: MediaQuery.of(context).size.height * 0.06,
            // width: MediaQuery.of(context).size.height * 0.5,
            child: ListTile(
              leading: Text(
                "Son işlemler",
                style: TextStyle(fontSize: 18),
              ),
              //   trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width * 0.9,
          color: Colors.grey,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.grey[200],
          ),
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.builder(
            itemCount: counter,
            itemBuilder: (BuildContext ctxt, int index) {
              return ekleme(
                name == null
                    ? ""
                    : "${name[0].toUpperCase() + surname[0].toUpperCase()}",
                trans[counter - index - 1]['price'],
                trans[counter - index - 1]['date'],
              );
            },
          ),
        ),
      ],
    );
  }

  ekleme(String name, String tutar, String day) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.purple,
        child: Text("$name"),
      ),
      trailing: Icon(Icons.attach_money),
      title: Text("İşlem Tutarı: $tutar₺"),
      subtitle: Text("$day"),
    );
  }

  chart() {
    return Container(
      height: MediaQuery.of(context).size.width * 0.6,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(3, 5), // changes position of shadow
          ),
        ],
      ),
      child: SfRadialGauge(
        // title: GaugeTitle(
        //   text: "Bisiklet",
        //   textStyle: GoogleFonts.poppins(fontSize: 40),
        // ),
        axes: <RadialAxis>[
          RadialAxis(
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                positionFactor: 0.1,
                angle: 89,
                widget: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${datas['biriken']}₺ / ${datas['hedef_fiyati']}₺',
                        style: GoogleFonts.poppins(
                            fontSize: priceInChart.length > 10 ? 20 : 25,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "%${bugFixer ? 0 : (100 * int.parse(datas['biriken']) / int.parse(datas['hedef_fiyati'])).toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                            fontSize: 27, color: Colors.red),
                      )
                    ],
                  ),
                ),
              )
            ],
            radiusFactor: 0.9,
            pointers: <GaugePointer>[
              RangePointer(
                color: Colors.green,
                value: 100 *
                    int.parse(datas['biriken']) /
                    int.parse(datas['hedef_fiyati']),
                cornerStyle: CornerStyle.bothCurve,
                width: 0.2,
                sizeUnit: GaugeSizeUnit.factor,
              )
            ],
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            axisLineStyle: AxisLineStyle(
              thickness: 0.2,
              cornerStyle: CornerStyle.endCurve,
              color: Color.fromARGB(30, 50, 150, 200),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
          )
        ],
      ),
    );
  }

  buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(3, 5), // changes position of shadow
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialog("Ne kadar ihanet etmek istiyorsun ?", true);
                  });
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 35,
              child: Icon(
                Icons.remove,
                size: 50,
                color: Colors.black54,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(3, 5), // changes position of shadow
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialog(
                        "Hayallerine ne kadar ulaşmak istiyorsun ?", false);
                  });
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 35,
              child: Icon(
                Icons.add,
                size: 50,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  dialog(String title, bool durum) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, title, durum),
    );
  }

  contentBox(context, String title, bool durum) {
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
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2),
                child: MyTextFormField(
                  controller: eklemeTutari,
                  keyboardType: TextInputType.phone,
                  validator: (String val) {
                    if (isNumeric(val) == false) {
                      return "Sadece sayı giriniz*";
                    }
                    if (val.length < 7) {
                      return "Para sınırını aştınız!";
                    }
                  },
                ),
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        if (durum == false) {
                          if (double.parse(datas['biriken']) +
                                  double.parse(eklemeTutari.text) >=
                              double.parse(datas['hedef_fiyati'])) {
                            //    Navigator.pop(context);
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => HedefBitti(widget.id)));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HedefBitti(widget.id)));
                          } else {
                            if (eklemeTutari.text.length < 7) {
                              playAudio(durum);
                              remove(durum, int.parse(eklemeTutari.text));
                              Navigator.of(context).pop();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Ekleme tutarı 7 haneden fazla olamaz",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM_LEFT,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                        } else if (durum == true) {
                          if (double.parse(datas['biriken']) -
                                  double.parse(eklemeTutari.text) <
                              0) {
                            Fluttertoast.showToast(
                                msg:
                                    "Çıkarmak istediğiniz tutar kumbaranızdaki paradan daha fazla!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM_LEFT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            if (eklemeTutari.text.length < 7) {
                              playAudio(durum);
                              remove(durum, int.parse(eklemeTutari.text));
                              Navigator.of(context).pop();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Ekleme tutarı 7 haneden fazla olamaz",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM_LEFT,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                        }
                      }
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
