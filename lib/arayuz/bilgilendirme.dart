import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ilk_projem/arayuz/info.dart';

class Bilgilendirme extends StatefulWidget {
  @override
  _Bilgilendirme createState() => _Bilgilendirme();
}

class _Bilgilendirme extends State<Bilgilendirme> {
  bool isAllSelect = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(   
        crossAxisAlignment: CrossAxisAlignment.center,
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: [
          tabBar(),
          isAllSelect == true ? Info() : Info(),
        ],
      ),
    );
  }

  tabBar() {
    return Container(
      height: 36,
      width: MediaQuery.of(context).size.width - 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            blurRadius: 5.0,
            spreadRadius: 1,
            offset: Offset(0.0, 1),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                isAllSelect = true;
                print(isAllSelect);
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 150),
              height: 48,
              width: (MediaQuery.of(context).size.width - 48) / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: isAllSelect ? Colors.green : Colors.white,
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Bilgilendirme",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isAllSelect ? Colors.white : Color(0xFF5D6A78),
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isAllSelect = false;
                print(isAllSelect);
              });
            },
            child: AnimatedContainer(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 150),
                height: 48,
                width: (MediaQuery.of(context).size.width - 48) / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: !isAllSelect ? Colors.green : Colors.white,
                ),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "S.S.S.",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: !isAllSelect ? Colors.white : Color(0xFF5D6A78),
                        fontWeight: FontWeight.w600,
                      ),
                    ))),
          )
        ],
      ),
    );
  }
}
