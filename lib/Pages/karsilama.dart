import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzade_rezervasyon/Services/globals.dart' as globals;

class KarsilamaEkran extends StatefulWidget {
  @override
  _KarsilamaEkranState createState() => _KarsilamaEkranState();
}

class _KarsilamaEkranState extends State<KarsilamaEkran> {
  goBack() {
    Navigator.of(context).pushNamed('/menu');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Uyarı'),
          content: Text('Çıkış yapmak istediğine emin misin?'),
          actions: [
            FlatButton(
              child: Text('Evet'),
              onPressed: () {
                final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                _firebaseAuth.signOut();
                Navigator.pop(c, false);
                Navigator.pushNamed(context, '/login');
              },
            ),
            FlatButton(
              child: Text('Hayır'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: new Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new ExactAssetImage('assets/rezFoto.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                  child: new Container(
                    decoration:
                        new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: new Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            SafeArea(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 30, 20),
                      child: InkWell(
                          child: Text(
                            "Geri Bildirim Yap",
                            style: GoogleFonts.teko(
                              color: Colors.white,
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/geribildirim");
                          }),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: 175,
                        height: 175,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new ExactAssetImage('assets/logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            BotToast.showText(text: "Çok Yakında!!!");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                            ),
                            width: globals.telefonWidth * 0.65,
                            height: 50,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                    child: Text(
                                  "Zaten Hanzadedeyim",
                                  style: GoogleFonts.teko(
                                      color: Colors.black, fontSize: 20),
                                )),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "/bilgigirisi");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                            ),
                            width: globals.telefonWidth * 0.65,
                            height: 50,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Text(
                                    "Rezervasyon Yap",
                                    style: GoogleFonts.teko(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "/rezlerim");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                            ),
                            width: globals.telefonWidth * 0.65,
                            height: 50,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Text(
                                    "Rezervasyonlarım",
                                    style: GoogleFonts.teko(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
