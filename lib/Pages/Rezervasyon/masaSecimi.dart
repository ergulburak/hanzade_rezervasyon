import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzade_rezervasyon/Services/db.dart';
import 'package:hanzade_rezervasyon/Services/globals.dart' as globals;
import 'package:hanzade_rezervasyon/Services/tablo/masa.dart';
import 'package:hanzade_rezervasyon/Services/tablo/rezervasyon.dart';
import 'package:intl/intl.dart';

class MasaSecimi extends StatefulWidget {
  @override
  _MasaSecimiState createState() => _MasaSecimiState();
}

class _MasaSecimiState extends State<MasaSecimi> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Rezervasyon> rezervasyonListesi = [];
  bool gunDegisimiKontrol = false;

  _masaBilgiReturn(String id) {
    for (var temp in globals.masalarDurum) {
      if (temp.id == id) {
        return temp.durum;
      }
    }
  }

  rezervasyonKontrol() {
    Services.getRezervasyonAllByTarih(
            DateFormat('yyyy-MM-dd').format(globals.rezervasyonTarih))
        .then((value) {
      if (DateFormat('yyyy-MM-dd').format(globals.rezervasyonTarih) ==
          DateFormat('yyyy-MM-dd').format(DateTime.now())) {
        rezervasyonListesi = value;
        int boluIkiKontrol = 0;
        for (Masa element in globals.masalar) {
          int temp = 0;
          for (Rezervasyon rezervasyon in rezervasyonListesi) {
            if (element.qrMasano == rezervasyon.rezervasyonMasa) {
              DateTime rezTarih = DateFormat('yyyy-MM-dd HH:mm')
                  .parse(rezervasyon.rezervasyonTarih);
              Duration fark = rezTarih.difference(globals.rezervasyonTarih);
              print("Tarih Rezervasyon : " + rezervasyon.rezervasyonTarih);
              print("Tarih Seçilen : " +
                  DateFormat('yyyy-MM-dd HH:mm')
                      .format(globals.rezervasyonTarih));
              print("Fark : " + fark.inHours.toString());
              int farkInt = fark.inHours;
              if (farkInt < 0) farkInt *= -1;
              if (farkInt < 4) {
                temp++;
                print(element.qrMasano +
                    " Masası nın farkı:" +
                    fark.inHours.toString() +
                    " FarkINT:" +
                    farkInt.toString());
              }
            }
          }
          if (temp >= 1) {
            element.masaRezDurumu = true;
            boluIkiKontrol++;
            if (boluIkiKontrol >= globals.masalar.length / 2) {
              for (var elem in globals.masalar) {
                elem.masaRezDurumu = true;
              }
            }
          } else if (_masaBilgiReturn(element.id) == "Dolu" ||
              _masaBilgiReturn(element.id) == "Birleşmiş") {
            element.masaRezDurumu = true;
          } else {
            if (boluIkiKontrol >= globals.masalar.length / 2) {
            } else
              element.masaRezDurumu = false;
          }
          if (element.masaRezDurumu == true &&
              globals.rezervasyonMasa == element.qrMasano)
            globals.rezervasyonMasa = null;
        }
        gunDegisimiKontrol = false;
        setState(() {});
      } else {
        rezervasyonListesi = value;
        int boluIkiKontrol = 0;
        for (Masa element in globals.masalar) {
          int temp = 0;
          for (Rezervasyon rezervasyon in rezervasyonListesi) {
            if (element.qrMasano == rezervasyon.rezervasyonMasa) {
              DateTime rezTarih = DateFormat('yyyy-MM-dd HH:mm')
                  .parse(rezervasyon.rezervasyonTarih);
              Duration fark = rezTarih.difference(globals.rezervasyonTarih);
              print("Tarih Rezervasyon : " + rezervasyon.rezervasyonTarih);
              print("Tarih Seçilen : " +
                  DateFormat('yyyy-MM-dd HH:mm')
                      .format(globals.rezervasyonTarih));
              print("Fark : " + fark.inHours.toString());
              int farkInt = fark.inHours;
              if (farkInt < 0) farkInt *= -1;
              if (farkInt < 4) {
                temp++;
              }
            }
          }
          if (temp >= 1) {
            element.masaRezDurumu = true;
            boluIkiKontrol++;
            if (boluIkiKontrol >= globals.masalar.length / 2) {
              for (var elem in globals.masalar) {
                elem.masaRezDurumu = true;
              }
            }
          } else {
            if (boluIkiKontrol >= globals.masalar.length / 2) {
            } else
              element.masaRezDurumu = false;
          }
          if (element.masaRezDurumu == true &&
              globals.rezervasyonMasa == element.qrMasano)
            globals.rezervasyonMasa = null;
        }
        gunDegisimiKontrol = false;
        setState(() {});
      }
    });
  }

  saatDegisinceKontol() {
    if (DateFormat('yyyy-MM-dd').format(globals.rezervasyonTarih) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      int boluIkiKontrol = 0;
      for (Masa element in globals.masalar) {
        int temp = 0;
        for (Rezervasyon rezervasyon in rezervasyonListesi) {
          if (element.qrMasano == rezervasyon.rezervasyonMasa) {
            DateTime rezTarih = DateFormat('yyyy-MM-dd HH:mm')
                .parse(rezervasyon.rezervasyonTarih);
            Duration fark = rezTarih.difference(globals.rezervasyonTarih);
            print("Tarih Rezervasyon : " + rezervasyon.rezervasyonTarih);
            print("Tarih Seçilen : " +
                DateFormat('yyyy-MM-dd HH:mm')
                    .format(globals.rezervasyonTarih));
            print("Fark : " + fark.inHours.toString());
            int farkInt = fark.inHours;
            if (farkInt < 0) farkInt *= -1;
            if (farkInt < 4) {
              temp++;
            }
          }
        }
        if (temp >= 1) {
          element.masaRezDurumu = true;
          boluIkiKontrol++;
          if (boluIkiKontrol >= globals.masalar.length / 2) {
            for (var elem in globals.masalar) {
              elem.masaRezDurumu = true;
            }
          }
        } else if (_masaBilgiReturn(element.id) == "Dolu" ||
            _masaBilgiReturn(element.id) == "Birleşmiş") {
          element.masaRezDurumu = true;
        } else {
          if (boluIkiKontrol >= globals.masalar.length / 2) {
          } else
            element.masaRezDurumu = false;
        }
        if (element.masaRezDurumu == true &&
            globals.rezervasyonMasa == element.qrMasano)
          globals.rezervasyonMasa = null;
      }
      setState(() {});
    } else {
      int boluIkiKontrol = 0;
      for (Masa element in globals.masalar) {
        int temp = 0;
        for (Rezervasyon rezervasyon in rezervasyonListesi) {
          if (element.qrMasano == rezervasyon.rezervasyonMasa) {
            DateTime rezTarih = DateFormat('yyyy-MM-dd HH:mm')
                .parse(rezervasyon.rezervasyonTarih);
            Duration fark = rezTarih.difference(globals.rezervasyonTarih);
            print("Tarih Rezervasyon : " + rezervasyon.rezervasyonTarih);
            print("Tarih Seçilen : " +
                DateFormat('yyyy-MM-dd HH:mm')
                    .format(globals.rezervasyonTarih));
            print("Fark : " + fark.inHours.toString());
            int farkInt = fark.inHours;
            if (farkInt < 0) farkInt *= -1;
            if (farkInt < 4) {
              temp++;
            }
          }
        }
        if (temp >= 1) {
          element.masaRezDurumu = true;
          boluIkiKontrol++;
          if (boluIkiKontrol >= globals.masalar.length / 2) {
            for (var elem in globals.masalar) {
              elem.masaRezDurumu = true;
            }
          }
        } else {
          if (boluIkiKontrol >= globals.masalar.length / 2) {
          } else
            element.masaRezDurumu = false;
        }
        if (element.masaRezDurumu == true &&
            globals.rezervasyonMasa == element.qrMasano)
          globals.rezervasyonMasa = null;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    rezervasyonKontrol();
    super.initState();
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
            SafeArea(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.66,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey[800].withOpacity(.8),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50))),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Container(
                                    height: 70,
                                    width: 225,
                                    decoration: BoxDecoration(
                                      color:
                                          hexToColor("#BF8773").withOpacity(.8),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "SAHNE",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28.0,
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            rezervasyonListesi == null
                                ? Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : gunDegisimiKontrol
                                    ? Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Expanded(
                                        flex: 1,
                                        child: GridView.count(
                                          primary: false,
                                          padding: EdgeInsets.all(20),
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          crossAxisCount: 4,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: globals
                                                      .masalar[0].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "1";
                                                      print("1");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[0]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "1"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                            InkWell(
                                              onTap: globals
                                                      .masalar[1].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "2";
                                                      print("2");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[1]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "2"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                            InkWell(
                                              onTap: globals
                                                      .masalar[2].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "3";
                                                      print("3");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[2]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "3"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                            InkWell(
                                              onTap: globals
                                                      .masalar[3].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "4";
                                                      print("4");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[3]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "4"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                            InkWell(
                                              onTap: globals
                                                      .masalar[4].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "5";
                                                      print("5");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[4]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "5"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                            InkWell(
                                              onTap: globals
                                                      .masalar[5].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "6";
                                                      print("6");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[5]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "6"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                            InkWell(
                                              onTap: globals
                                                      .masalar[6].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "7";
                                                      print("7");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[6]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "7"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                            InkWell(
                                              onTap: globals
                                                      .masalar[7].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "8";
                                                      print("8");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[7]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "8"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                            InkWell(
                                              onTap: globals
                                                      .masalar[8].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "9";
                                                      print("9");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[8]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "9"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                            InkWell(
                                              onTap: globals
                                                      .masalar[9].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "10";
                                                      print("10");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[9]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "10"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                            InkWell(
                                              onTap: globals
                                                      .masalar[10].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "11";
                                                      print("11");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[10]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "11"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                            InkWell(
                                              onTap: globals
                                                      .masalar[11].masaRezDurumu
                                                  ? () {}
                                                  : () {
                                                      globals.rezervasyonMasa =
                                                          "12";
                                                      print("12");
                                                      setState(() {});
                                                    },
                                              child: SvgPicture.asset(
                                                "assets/table.svg",
                                                color: globals.masalar[11]
                                                        .masaRezDurumu
                                                    ? Colors.red
                                                    : globals.rezervasyonMasa ==
                                                            "12"
                                                        ? Colors.amber
                                                        : Colors.green,
                                                matchTextDirection: true,
                                                semanticsLabel: "Masa1",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        String saat = DateFormat('HH').format(
                                            globals.rezervasyonTarih
                                                .add(Duration(hours: -1)));
                                        int saatINT = int.parse(saat);

                                        if (saatINT < 8) {
                                          if (globals.rezervasyonTarih
                                              .isBefore(DateTime.now())) {
                                          } else {
                                            globals.rezervasyonTarih = globals
                                                .rezervasyonTarih
                                                .add(Duration(days: -1));
                                            var time = globals.rezervasyonTarih;
                                            globals.rezervasyonTarih =
                                                new DateTime(
                                                    time.year,
                                                    time.month,
                                                    time.day,
                                                    21,
                                                    00,
                                                    time.second,
                                                    time.millisecond,
                                                    time.microsecond);
                                            gunDegisimiKontrol = true;
                                            rezervasyonKontrol();
                                          }
                                        } else {
                                          String saat2 = DateFormat('HH')
                                              .format(globals.rezervasyonTarih
                                                  .add(Duration(hours: -1)));
                                          int saatINT2 = int.parse(saat2);
                                          String saat3 = DateFormat('HH')
                                              .format(DateTime.now());
                                          int saatINT3 = int.parse(saat3);
                                          print("Saat2:" +
                                              saat2 +
                                              " Saat3:" +
                                              saat3);
                                          if (saatINT2 < saatINT3 + 1) {
                                          } else {
                                            globals.rezervasyonTarih = globals
                                                .rezervasyonTarih
                                                .add(Duration(hours: -1));
                                            saatDegisinceKontol();
                                          }
                                        }
                                        setState(() {});
                                      },
                                      hoverColor: Colors.white,
                                      splashColor: Colors.white,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      DateFormat('yyyy-MM-dd HH:mm')
                                          .format(globals.rezervasyonTarih),
                                      style: GoogleFonts.teko(
                                        color: Colors.white,
                                        letterSpacing: 2.0,
                                        fontSize: 24,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        String saat = DateFormat('HH').format(
                                            globals.rezervasyonTarih
                                                .add(Duration(hours: 1)));
                                        int saatINT = int.parse(saat);

                                        if (saatINT >= 22) {
                                          globals.rezervasyonTarih = globals
                                              .rezervasyonTarih
                                              .add(Duration(days: 1));
                                          var time = globals.rezervasyonTarih;
                                          globals.rezervasyonTarih =
                                              new DateTime(
                                                  time.year,
                                                  time.month,
                                                  time.day,
                                                  08,
                                                  00,
                                                  time.second,
                                                  time.millisecond,
                                                  time.microsecond);
                                          gunDegisimiKontrol = true;
                                          rezervasyonKontrol();
                                        } else {
                                          globals.rezervasyonTarih = globals
                                              .rezervasyonTarih
                                              .add(Duration(hours: 1));
                                          saatDegisinceKontol();
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'MASA NO',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      globals.rezervasyonMasa == null
                                          ? "Seçilmedi"
                                          : globals.rezervasyonMasa,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                    SizedBox(height: 25.0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        height: 184,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  _firebaseAuth.currentUser().then(
                                    (value) {
                                      if (globals.rezervasyonMasa != null) {
                                        Navigator.pushNamed(
                                            context, "/rezonizleme",
                                            arguments: value);
                                      } else {
                                        BotToast.showText(
                                            text: "Masa Seçiniz.");
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  width: globals.telefonWidth * 0.65,
                                  height: 50,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                        child: Text(
                                          "Devam",
                                          style: GoogleFonts.teko(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.lens,
                                        size: 10,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        "Kırmızı renkli masalar doludur.",
                                        style: GoogleFonts.teko(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.lens,
                                        size: 10,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        "Yeşil renkli masalar rezervasyon için uygundur.",
                                        style: GoogleFonts.teko(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.lens,
                                        size: 10,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        "Sarı renkli masa sizin seçtiğiniz masadır.",
                                        style: GoogleFonts.teko(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
