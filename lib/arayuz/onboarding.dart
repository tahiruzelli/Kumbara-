import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void setisFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFirstTime", false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF4CAF50),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFF3D8C40),
                Color(0xFF327334),
                Color(0xFF275929),
                Color(0xFF1C401D),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () => setisFirstTime(),
                    child: Text(
                      'Geç',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/onboarding0.png',
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.height * 0.25,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Türkiyenin farklı bölgelerinden farklı birikimciler',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CM Sans Serif',
                                fontSize: 26.0,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Binlerce farklı birikimciler arasından en kötü birikimciler arasında yer alıp Utanç Tablosuna düşmemek için kıyasıya yarış!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/onboarding1.png',
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.height * 0.2,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Bizimle\nBirikimini daha kolay yap!',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CM Sans Serif',
                                fontSize: 26.0,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Finansal Okuryazar eğitmenlerimiz tarafından hazırlanmış para biriktirme makalesi, zengin görsel içerikler ve günlük olarak sana gelecek olan motivasyon tazeleyici bildirimler ile para biriktirmek artık çok kolay!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/onboarding2.png',
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.height * 0.25,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Bu uygulamayı\nKendinize saklamayın!',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CM Sans Serif',
                                fontSize: 26.0,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Çevrenizdeki insanlara bu uygulamadan bahsederek onların da para biriktirmesine yardımcı olun!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'İleri',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: MediaQuery.of(context).size.height*0.15,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () => setisFirstTime(),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Haydi Başlayalım',
                      style: TextStyle(
                        color: Color(0xFF3D8C40),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
