import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzade_rezervasyon/Services/db.dart';
import 'package:hanzade_rezervasyon/Services/tablo/rezervasyon.dart';
import 'package:intl/intl.dart';

class Rezervasyonlarim extends StatefulWidget {
  @override
  _RezervasyonlarimState createState() => _RezervasyonlarimState();
}

class _RezervasyonlarimState extends State<Rezervasyonlarim> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Rezervasyon> _rezervasyonListesi = [];
  bool rezGelisiKontrol = false;
  _rezervasyonumuGetir() {
    _firebaseAuth.currentUser().then((value) {
      Services.getRezervasyonumuGetir(value.email).then((gelenRez) {
        _rezervasyonListesi = gelenRez;
        rezGelisiKontrol = true;
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
      onWillPop: () => Future.value(true),
      child: Scaffold(
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
            !rezGelisiKontrol
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Rezervasyonlarım",
                              style: GoogleFonts.teko(
                                color: Colors.white,
                                fontSize: 40,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          _rezervasyonListesi.length != 0
                              ? Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      child: ListView.builder(
                                        itemCount: _rezervasyonListesi.length,
                                        itemBuilder: (context, index) {
                                          return _bilgiCard(
                                              _rezervasyonListesi[index]
                                                  .rezervasyonTarih,
                                              _rezervasyonListesi[index]
                                                  .rezervasyonMasa,
                                              _rezervasyonListesi[index]
                                                  .rezervasyonKisiSayisi,
                                              _rezervasyonListesi[index]
                                                  .rezervasyonNotu,
                                              _rezervasyonListesi[index].id,
                                              index);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      20,
                                      (MediaQuery.of(context).size.height / 2) -
                                          60,
                                      20,
                                      10,
                                    ),
                                    child: Text(
                                      "KAYITLI REZERVASYON BULUNAMADI.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                          _rezervasyonListesi.length != 0
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "İptal etmek için yana kaydırın.",
                                        style: GoogleFonts.teko(
                                          color: Colors.white,
                                          fontSize: 20,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _bilgiCard(String tarih, String masaNo, String kisiSayisi, String not,
      String id, int index) {
    DateTime tarihim = DateFormat('yyyy-MM-dd HH:mm').parse(tarih);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2.5, 0, 2.5),
      child: Dismissible(
        background: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.red),
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Sil",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 70),
            ),
          ),
        ),
        key: UniqueKey(),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[900],
              ),
              height: 190,
              width: MediaQuery.of(context).size.width - 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 15, 20),
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 20) / 2.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "TARİH",
                            style: TextStyle(
                                color: Colors.grey[100],
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  DateFormat('dd-MM-yyyy').format(tarihim),
                                  style: TextStyle(
                                      color: Colors.grey[100],
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20),
                                ),
                                Text(
                                  DateFormat('HH:mm').format(tarihim),
                                  style: TextStyle(
                                      color: Colors.grey[100],
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "MASA NO",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              masaNo,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 15, 20),
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 20) / 2.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "KİŞİ SAYISI",
                            style: TextStyle(
                              color: Colors.grey[100],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              kisiSayisi,
                              style: TextStyle(
                                  color: Colors.grey[100],
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "NOT",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            not != "" ? not : "Not yok.",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 10),
                            maxLines: 4,
                            overflowReplacement:
                                Text('Not görüntülenemeyecek kadar uzun'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Uyarı'),
                content: Text('Silmek istediğine emin misin?'),
                actions: [
                  FlatButton(
                    child: Text('Evet'),
                    onPressed: () {
                      Services.rezervasyonSil(id).then((value) {
                        _rezervasyonListesi.removeAt(index);
                        Navigator.pop(c, false);
                        setState(() {});
                      });
                    },
                  ),
                  FlatButton(
                    child: Text('Hayır'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
