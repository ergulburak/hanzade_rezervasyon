import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzade_rezervasyon/Services/db.dart';
import 'package:hanzade_rezervasyon/Services/globals.dart' as globals;
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart';

class RezervasyonOnizleme extends StatefulWidget {
  RezervasyonOnizleme({this.user});
  final FirebaseUser user;
  @override
  _RezervasyonOnizlemeState createState() => _RezervasyonOnizlemeState();
}

class _RezervasyonOnizlemeState extends State<RezervasyonOnizleme> {
  bool butonKont = false;

  @override
  void initState() {
    super.initState();
  }

  smsOnay() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.user.phoneNumber,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (credential) async {
          print("Başarılı.");
          final _lock = new Lock();
          await _lock.synchronized(() async {
            Services.addRezervasyon(
              widget.user.displayName,
              widget.user.phoneNumber,
              widget.user.email,
              globals.rezervasyonKisiSayisi == "5"
                  ? "4+"
                  : globals.rezervasyonKisiSayisi,
              globals.rezervasyonNotu,
              globals.rezervasyonMasa,
              DateFormat('yyyy-MM-dd HH:mm').format(globals.rezervasyonTarih),
            ).then((value) {
              butonKont = false;
              Navigator.of(context).pushNamed("/karsilama");
              BotToast.showNotification(
                  leading: (cancel) => SizedBox.fromSize(
                      size: const Size(40, 40),
                      child: IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.green),
                        onPressed: cancel,
                      )),
                  title: (_) => Text('Rezervasyon Başarılı.'),
                  subtitle: (_) => Text(DateFormat('yyyy-MM-dd HH:mm')
                          .format(globals.rezervasyonTarih) +
                      " Tarihinde sizi bekliyoruz!"),
                  trailing: (cancel) => IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: cancel,
                      ),
                  enableSlideOff: true,
                  backButtonBehavior: BackButtonBehavior.none,
                  crossPage: true,
                  align: Alignment.bottomCenter,
                  contentPadding: EdgeInsets.all(10),
                  onlyOne: true,
                  animationDuration: Duration(milliseconds: 200),
                  animationReverseDuration: Duration(milliseconds: 200),
                  duration: Duration(seconds: 5));
            });
          });
        },
        verificationFailed: null,
        codeSent: (verificationId, [forceResendingToken]) async {
          print("Kod Yollandı.");
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Uyarı'),
          content: Text('Rezervasyonu iptal etmek istediğine emin misin?'),
          actions: [
            FlatButton(
              child: Text('Evet'),
              onPressed: () {
                Navigator.pop(c, false);
                Navigator.pushNamed(context, "/karsilama");
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
            butonKont ? Center(child: CircularProgressIndicator()) : onizleme(),
          ],
        ),
      ),
    );
  }

  onizleme() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'İSİM',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  widget.user.displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 25.0),
                Text(
                  'E-POSTA',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10.0),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.user.email,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                Text(
                  'GSM',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  widget.user.phoneNumber,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 25.0),
                Text(
                  'TARİH',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm')
                      .format(globals.rezervasyonTarih),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 25.0),
                Text(
                  'KİŞİ SAYISI',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  globals.rezervasyonKisiSayisi == "5"
                      ? "4+"
                      : globals.rezervasyonKisiSayisi,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 25.0),
                Text(
                  'MASA NO',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  globals.rezervasyonMasa,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 25.0),
                Text(
                  'NOT',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 90,
                  child: Text(
                    globals.rezervasyonNotu,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        butonKont = true;
                        setState(() {});
                        smsOnay();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                        ),
                        width: globals.telefonWidth * 0.65,
                        height: 50,
                        child: Center(
                          child: Text(
                            "Rezervasyonu Onayla",
                            style: GoogleFonts.roboto(
                                color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
