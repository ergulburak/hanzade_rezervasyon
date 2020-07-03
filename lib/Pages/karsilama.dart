import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzade_rezervasyon/Services/db.dart';
import 'package:hanzade_rezervasyon/Services/globals.dart' as globals;
import 'package:hanzade_rezervasyon/Services/tablo/rezervasyon.dart';
import 'package:intl/intl.dart';

class KarsilamaEkran extends StatefulWidget {
  @override
  _KarsilamaEkranState createState() => _KarsilamaEkranState();
}

class _KarsilamaEkranState extends State<KarsilamaEkran> {
  goBack() {
    Navigator.of(context).pushNamed('/menu');
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Rezervasyon> _rezervasyonListesi = [];
  Rezervasyon _kiyaslanacakRez;
  bool rezGelisiKontrol = false;
  bool rezVarmi = true;
  _rezervasyonumuGetir() {
    _firebaseAuth.currentUser().then((value) {
      Services.getRezervasyonumuGetir(value.email).then((gelenRez) {
        _rezervasyonListesi = gelenRez;
        rezGelisiKontrol = true;
        if (_rezervasyonListesi.length > 0) {
          if (_rezervasyonListesi.length == 1) {
            _kiyaslanacakRez = _rezervasyonListesi[0];
          } else {
            int temp = 0;
            _rezervasyonListesi.forEach((element) {
              if (int.parse(element.id) > temp) {
                temp = int.parse(element.id);
                _kiyaslanacakRez = element;
              }
            });
          }
        } else {
          rezVarmi = false;
        }
        setState(() {});
      });
    });
  }

  @override
  void initState() {
    _rezervasyonumuGetir();
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
                          onTap: rezGelisiKontrol
                              ? () {
                                  if (rezVarmi) {
                                    DateTime rezTarih =
                                        DateFormat('yyyy-MM-dd HH:mm').parse(
                                            _kiyaslanacakRez
                                                .rezervasyonOlusturulmaZamani);
                                    Duration fark =
                                        DateTime.now().difference(rezTarih);

                                    if (fark.inMinutes < 5) {
                                      BotToast.showNotification(
                                          leading: (cancel) =>
                                              SizedBox.fromSize(
                                                  size: const Size(40, 40),
                                                  child: IconButton(
                                                    icon: Icon(Icons.warning,
                                                        color: Colors.red),
                                                    onPressed: cancel,
                                                  )),
                                          title: (_) => Text('Spam Engeli'),
                                          subtitle: (_) => Text(
                                              "Çok hızlı rezervasyon yapmayı denedin.\nLütfen biraz bekleyip tekrar deneyiniz."),
                                          trailing: (cancel) => IconButton(
                                                icon: Icon(Icons.cancel),
                                                onPressed: cancel,
                                              ),
                                          enableSlideOff: true,
                                          backButtonBehavior:
                                              BackButtonBehavior.none,
                                          crossPage: true,
                                          align: Alignment.topCenter,
                                          contentPadding: EdgeInsets.all(10),
                                          onlyOne: true,
                                          animationDuration:
                                              Duration(milliseconds: 200),
                                          animationReverseDuration:
                                              Duration(milliseconds: 200),
                                          duration: Duration(seconds: 5));
                                    } else {
                                      Navigator.pushNamed(
                                          context, "/bilgigirisi");
                                    }
                                  } else {
                                    print("burada");
                                    Navigator.pushNamed(
                                        context, "/bilgigirisi");
                                  }
                                }
                              : () {},
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
