import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ilk_projem/arayuz/faq.dart';
import 'package:ilk_projem/arayuz/main_page.dart';
import 'package:ilk_projem/arayuz/profile.dart';
import 'package:ilk_projem/arayuz/shame_table.dart';
import 'package:ilk_projem/services/advert-service.dart';

class HomeNavigator extends StatefulWidget {
  String id;

  HomeNavigator(this.id);
  _HomeNavigator createState() => _HomeNavigator();
}

class _HomeNavigator extends State<HomeNavigator> {
  final Firestore firestore = Firestore.instance;
  DateTime now = DateTime.now();
  final AdvertService _advertService = AdvertService();
  void setShamePoint() async {
    Timestamp t;
    double biriken;
    int gecenSure;
    double puan;
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore.collection("users").document(widget.id).get();
      t = documentSnapshot.data['startDate'];
      gecenSure = now.day - t.toDate().day;
      /*----------------------------------------*/

      biriken = 100 *
          int.parse(documentSnapshot.data['biriken']) /
          int.parse(documentSnapshot.data['hedef_fiyati']);

      puan = ((gecenSure * (100 - biriken)) / (100 * biriken));
      firestore.collection("users").document(widget.id).updateData({
        "puan": puan,
      });
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState(){
  //  _advertService.showIntersitial();
   // setShamePoint();
    super.initState();
  }
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List pages = [
      MyHomePage(widget.id),
      ShameTable(widget.id),
      Faq(),
      Profile(widget.id),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/logoVeYaziDark.png",
              fit: BoxFit.cover,
              height: 42.0,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Ana Sayfa'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.mood_bad),
            title: Text(
              'Utanç Tablosu',
              style: TextStyle(fontSize: 12),
            ),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.info_outline),
            title: Text(
              'Bilgilendirme',
              style: TextStyle(fontSize: 13),
            ),
            activeColor: Colors.lightGreen,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Profilim'),
            activeColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
