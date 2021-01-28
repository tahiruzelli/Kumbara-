import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool toggleValue =true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFCFCFC),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Profilim",
                  style: GoogleFonts.poppins(
                      fontSize: 18, color: Color(0xFF5D6A78)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Container(
                  width: 28,
                  child: Divider(
                    color: Colors.green,
                    height: 3,
                    thickness: 2,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                },
                leading: Icon(
                  Icons.lock_outline,
                  color: Color(0xFF5D6A78),
                ),
                title: Text(
                  "Şifremi Değiştir",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Color(0xFF5D6A78),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ListTile(
                trailing: Switch(
                  value: toggleValue,
                  onChanged: (value)  {
                    setState(() {
                      toggleValue = !toggleValue;
                    });
                  },
                  activeTrackColor: Color(0xFF596ee1),
                  activeColor: Colors.white,
                ),
                onTap: () {},
                leading: Icon(Icons.notifications_none,color:Color(0xFF5D6A78) ,),
                title: Text(
                  "Bildirim Ayarları",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Color(0xFF5D6A78),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.person_outline,
                  size: 22,
                  color: Color(0xFF5D6A78),
                ),
                title: Text(
                  "Kişisel Bilgilerim",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Color(0xFF5D6A78),
                  ),
                ),
              ),
              Spacer(),
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.exit_to_app,
                  color: Color(0xFF5D6A78),
                  size: 20,
                ),
                title: Text(
                  "Çıkış Yap",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Color(0xFF5D6A78),
                  ),
                ),
              ),
              //SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(Color color) {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Profilim",
        style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
    );
  }
}
