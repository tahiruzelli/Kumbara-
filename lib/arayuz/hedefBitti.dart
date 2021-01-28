import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ilk_projem/arayuz/ilkHedefim.dart';

class HedefBitti extends StatefulWidget {
  String id;
  HedefBitti(this.id);
  @override
  _HedefBitti createState() => _HedefBitti();
}

class _HedefBitti extends State<HedefBitti> {
  final Firestore firestore = Firestore.instance;
  AudioCache player = AudioCache();
  void tamamlananHedefArttir() async {
    String newSayi;
    DocumentSnapshot documentSnapshot;
    documentSnapshot =
        await firestore.collection("users").document(widget.id).get();
    newSayi = (int.parse(documentSnapshot['bitenHedefSayisi']) + 1).toString();
    firestore.collection("users").document(widget.id).updateData({
      "bitenHedefSayisi": newSayi,
    });
  }

  @override
  void initState() {
    Timer(
        Duration(seconds: 6),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => IlkHedefim(widget.id))));
    tamamlananHedefArttir();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    player.play("completed.mp3");

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Image.asset("assets/completed.gif"),
      ),
    );
  }
}
