import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ilk_projem/services/advert-service.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class ShameTable extends StatefulWidget {
  String id;
  ShameTable(this.id);
  @override
  _ShameTable createState() => _ShameTable();
}

class _ShameTable extends State<ShameTable> {
  final Firestore firestore = Firestore.instance;
  final AdvertService _advertService = AdvertService();
  DateTime now = DateTime.now();
  Timestamp t;
  int myIndex = 0;
  List users = [];
  List users2 = [];
  List allPoints = [];
  Map tmp;
  double biriken;
  int gecenSure;
  void getTable() async {
    QuerySnapshot _query = await firestore.collection("users").getDocuments();
    for (DocumentSnapshot snap in _query.documents) {
      // print(snap.data);
      users.add(snap.data);
    }
    // tüm puanları allpoints isimli listeye ekleme algoritması
    for (int i = 0; i < users.length; i++) {
      try {
        t = users[i]['startDate'];
        gecenSure = now.difference(t.toDate()).inDays;
        /*----------------------------------------*/

        if (gecenSure == 0) {
          gecenSure = 1;
        }
        if (users[i]['hedef_fiyati'] == "0") {
          users[i]['hedef_fiyati'] = "1";
        }
        biriken = 100 *
            int.parse(users[i]['biriken']) /
            int.parse(users[i]['hedef_fiyati']);

        users[i]['puan'] =
            (((int.parse(users[i]['targetDay']) / gecenSure) * 0.4 +
                        ((biriken) * 0.6)) /
                    10) +
                int.parse(users[i]['bitenHedefSayisi']);
      } catch (e) {
        users[i]['puan'] = 100.0;
        print(e);
      }
    }
    double key;
    int j;

    for (int i = 1; i < users.length; i++) {
      if (users[i]['puan'] < 3.14) {
        users[i]['puan'] = 9999.0;
      }
      if(users[0]['puan']<3.14){
        users[0]['puan'] = 9999.0;
      }
      key = users[i]['puan']; //take value
      j = i;
      while (j > 0 && users[j - 1]['puan'] > key) {
        tmp = users[j];
        users[j] = users[j - 1];
        users[j - 1] = tmp;
        j--;
      }
      setState(() {
        users[j]['puan'] = key;
      });
      // users[j]['puan'] = key;
      //insert in right place
    }
    // for (int i = 0; i < users.length; i++) {
    //   if (users[i]['puan'] == 0.0) {
    //     setState(() {
    //       users[i]['puan'] = 1000;
    //     });
    //   }
    // }
    for (int i = 0; i < users.length; i++) {
      if (users[i]['email'] == widget.id) {
        myIndex = i;
        break;
      }
    }
  }

  @override
  void initState() {
    //  _advertService.showBanner();
    getTable();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: users.length == 0
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
            : Container(
                height: s.height * 0.95,
                width: s.width,
                child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: s.height * 0.025),
                    Text(
                      "Utanç Tablosu",
                      style:
                          GoogleFonts.poppins(color: Colors.red, fontSize: 40),
                    ),
                    SizedBox(height: s.height * 0.05),
                    lider(s),
                    SizedBox(height: s.height * 0.05),
                    Column(
                      children: [
                        eleman2(
                            s,
                            "2",
                            "${users[1]['name']} ${users[1]['surname']}",
                            users[1]['puan'].toStringAsFixed(2),
                            Colors.red[400],
                            Colors.red[700],
                            Colors.red[900]),
                        eleman2(
                            s,
                            "3",
                            "${users[2]['name']} ${users[2]['surname']}",
                            users[2]['puan'].toStringAsFixed(2),
                            Colors.red[500],
                            Colors.red[700],
                            Colors.red[900]),
                        eleman2(
                            s,
                            "4",
                            "${users[3]['name']} ${users[3]['surname']}",
                            users[3]['puan'].toStringAsFixed(2),
                            Colors.red[500],
                            Colors.red[800],
                            Colors.red[900]),
                        eleman2(
                            s,
                            "5",
                            "${users[4]['name']} ${users[4]['surname']}",
                            users[4]['puan'].toStringAsFixed(2),
                            Colors.red[600],
                            Colors.red[900],
                            Colors.red[900]),
                      ],
                    ),
                    myIndex > 4
                        ? eleman2(
                            s,
                            "${myIndex + 1}",
                            "${users[myIndex]['name']} ${users[myIndex]['surname']}",
                            users[myIndex]['puan'].toStringAsFixed(2),
                            Colors.grey,
                            Colors.grey[600],
                            Colors.blueGrey[700])
                        : Container(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
      ),
    );
  }

  eleman2(Size s, String index, String name, String yuzde, Color color1,
      Color color2, Color color3) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: s.width * 0.025, vertical: 4),
      child: Container(
        width: s.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.red,
          gradient: LinearGradient(
            colors: [color1, color2],
          ),
        ),
        child: ListTile(
          // leading: sex == "man"
          //     ? Image.asset("assets/man.png")
          //     : Image.asset("assets/woman.png"),
          leading: Text(
            "$index.",
            style: GoogleFonts.poppins(fontSize: 30, color: Colors.white),
          ),
          title: Text(
            name,
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          trailing: ClipPolygon(
            sides: 6,
            borderRadius: 5.0, // Default 0.0 degrees
            rotate: 90.0, // Default 0.0 degrees
            boxShadows: [
              PolygonBoxShadow(color: Colors.white, elevation: 1.0),
              PolygonBoxShadow(color: Colors.white, elevation: 2.0)
            ],
            child: Container(
              color: color3,
              child: Center(
                child: Text(
                  "$yuzde",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  lider(Size s) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: s.width * 0.025),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset("assets/1943340.png",
                fit: BoxFit.fill, height: s.height * 0.25, width: s.width),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: s.width * 0.025),
          child: Container(
            height: s.height * 0.275,
            width: s.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "En Kötü Birikimci",
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.7),
                  radius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Image.asset("assets/2602574-200.png"),
                  ),
                ),
                Text(
                  "${users[0]['name']} ${users[0]['surname']}",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 30),
                ),
                Container(
                  height: s.height * 0.075,
                  child: ClipPolygon(
                    sides: 6,
                    borderRadius: 5.0, // Default 0.0 degrees
                    rotate: 90.0, // Default 0.0 degrees
                    boxShadows: [
                      PolygonBoxShadow(color: Colors.white, elevation: 1.0),
                      PolygonBoxShadow(color: Colors.white, elevation: 5.0)
                    ],
                    child: Container(
                      color: Colors.red[900],
                      child: Center(
                        child: Text(
                          "${users[0]['puan'].toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding eleman(String name, double yuzde, IconData icon, int index,
      Color color1, Color color2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [color1, Colors.pink[200], color2],
            // ),
            border: Border.all(
              color: color1,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: Colors.grey[200],
                offset: Offset(0, 2),
                spreadRadius: 1,
              ),
            ]),
        child: ListTile(
          // leading: sex == "man"
          //     ? Image.asset("assets/man.png")
          //     : Image.asset("assets/woman.png"),
          leading: Text(
            "${index + 1}.",
            style: GoogleFonts.poppins(
              fontSize: 30,
            ),
          ),
          title: Text(
            name,
            style: GoogleFonts.poppins(),
          ),
          subtitle: Text(
            "Başarı Yüzdesi: %$yuzde",
            style: GoogleFonts.poppins(),
          ),
          trailing: Icon(
            icon,
          ),
        ),
      ),
    );
  }
}
