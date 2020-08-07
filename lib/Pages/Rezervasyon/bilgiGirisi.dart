import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzade_rezervasyon/Services/db.dart';
import 'package:hanzade_rezervasyon/Services/globals.dart' as globals;
import 'package:hanzade_rezervasyon/Services/tablo/masa.dart';
import 'package:hanzade_rezervasyon/Services/tablo/masaDurum.dart';
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class BilgiGirisSayfasi extends StatefulWidget {
  @override
  _BilgiGirisSayfasiState createState() => _BilgiGirisSayfasiState();
}

class _BilgiGirisSayfasiState extends State<BilgiGirisSayfasi> {
  double _height = globals.telefonHeight * 0.60;
  double _width = globals.telefonWidth - 70;
  final _rezervasyonNotu = TextEditingController();
  final _rezervasyonTarihi = TextEditingController();
  int _secilenRadio;
  DateTime _secilenTarih;
  var formatla = new DateFormat('yyyy-MM-dd Hm');
  final formKey = GlobalKey<FormState>();

  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  List<Masa> _masalar = [];
  List<Masa> _bahce = [];
  List<Masa> _balkon = [];
  List<Masa> _salon = [];
  List<Masa> _sark = [];
  List<Masa> _otoYikama = [];
  List<Masa> _organizasyon = [];
  List<MasaDurum> _durum = [];
  bool devamKontrol = false;

  bool kont1 = false;
  bool kont2 = false;
  bool kont3 = false;
  bool kont4 = false;
  bool kont5 = false;
  bool kont6 = false;
  List items = [
    {'bolum': 'Bahçe'},
    {'bolum': 'Balkon'},
    {'bolum': 'Şark'},
    {'bolum': 'Salon'},
    {'bolum': 'Oto Yıkama'},
    {'bolum': 'Organizasyon'},
  ];
  final _lock = new Lock();
  _getMasa() async {
    await _lock.synchronized(() async {
      Services.getMasa().then((masa) {
        _masalar = masa;
        setState(() {
          Future.delayed(const Duration(seconds: 0), () => _setMasalar());
          Future.delayed(const Duration(seconds: 1), () => _masaBilgi())
              .then((value) {
            Navigator.pushNamed(context, "/masasecimi");
            devamKontrol = false;
          });
        });
      });
    });
  }

  _setMasalar() {
    _bahce = [];
    _balkon = [];
    _salon = [];
    _sark = [];
    _otoYikama = [];
    _organizasyon = [];
    for (Masa ornek in _masalar) {
      if (ornek.bolumid == "5") {
        _bahce.add(ornek);
      }
      if (ornek.bolumid == "2") {
        _balkon.add(ornek);
      }
      if (ornek.bolumid == "3") {
        _salon.add(ornek);
      }
      if (ornek.bolumid == "4") {
        _sark.add(ornek);
      }
      if (ornek.bolumid == "6") {
        _otoYikama.add(ornek);
      }
      if (ornek.bolumid == "7") {
        _organizasyon.add(ornek);
      }
    }
    globals.masalar = _bahce;
  }

  _masaBilgi() {
    _durum = [];
    MasaDurum temp;
    for (var durum in _masalar) {
      Services.masaBilgi(durum.id).then((value) {
        temp = new MasaDurum();
        temp.id = durum.id;
        temp.durum = value;
        _durum.add(temp);
      });
    }
    globals.masalarDurum = _durum;
  }

  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  @override
  void initState() {
    super.initState();
    _secilenRadio = 1;
  }

  int radioKont = 1;
  setSecilenRadio(int value) {
    if (value == 1) {
      radioKont = 1;
      setState(() {});
    }
    if (value == 2) {
      radioKont = 2;
      setState(() {});
    }
    if (value == 3) {
      radioKont = 3;
      setState(() {});
    }
    if (value == 4) {
      radioKont = 4;
      setState(() {});
    }
    if (value == 5) {
      radioKont = 5;
      BotToast.showNotification(
          leading: (cancel) => SizedBox.fromSize(
              size: const Size(40, 40),
              child: IconButton(
                icon: Icon(Icons.warning, color: Colors.red),
                onPressed: cancel,
              )),
          title: (_) => Text(
              '4 kişiden fazla rezervasyon yapmak için herkesin aile bireyi olması gerekir!'),
          enableSlideOff: true,
          backButtonBehavior: BackButtonBehavior.none,
          crossPage: true,
          align: Alignment.bottomCenter,
          contentPadding: EdgeInsets.all(10),
          onlyOne: true,
          animationDuration: Duration(milliseconds: 200),
          animationReverseDuration: Duration(milliseconds: 200),
          duration: Duration(seconds: 10));
      setState(() {});
    }
    setState(() {
      _secilenRadio = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, "/karsilama");
        return Future.value(false);
      },
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
                  MediaQuery.of(context).viewInsets.bottom != 0
                      ? Container()
                      : Align(
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
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 700),
                        curve: Curves.fastOutSlowIn,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(60))),
                        height: _height,
                        width: _width,
                        alignment: Alignment.center,
                        child: devamKontrol
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20,
                                          bottom: 10),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Kişi Sayısı",
                                              style: GoogleFonts.teko(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            Container()
                                          ]),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, right: 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300]
                                                .withOpacity(.3),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10))),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Row(children: <Widget>[
                                                Radio(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  value: 1,
                                                  groupValue: _secilenRadio,
                                                  onChanged: (value) {
                                                    setSecilenRadio(value);
                                                  },
                                                  activeColor: Colors.white,
                                                ),
                                                Text(
                                                  "1",
                                                  style: GoogleFonts.teko(
                                                      color: Colors.white),
                                                )
                                              ]),
                                              Row(children: <Widget>[
                                                Radio(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  value: 2,
                                                  groupValue: _secilenRadio,
                                                  onChanged: (value) {
                                                    setSecilenRadio(value);
                                                  },
                                                  activeColor: Colors.white,
                                                ),
                                                Text(
                                                  "2",
                                                  style: GoogleFonts.teko(
                                                      color: Colors.white),
                                                )
                                              ]),
                                              Row(children: <Widget>[
                                                Radio(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  value: 3,
                                                  groupValue: _secilenRadio,
                                                  onChanged: (value) {
                                                    setSecilenRadio(value);
                                                  },
                                                  activeColor: Colors.white,
                                                ),
                                                Text(
                                                  "3",
                                                  style: GoogleFonts.teko(
                                                      color: Colors.white),
                                                )
                                              ]),
                                              Row(children: <Widget>[
                                                Radio(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  value: 4,
                                                  groupValue: _secilenRadio,
                                                  onChanged: (value) {
                                                    setSecilenRadio(value);
                                                  },
                                                  activeColor: Colors.white,
                                                ),
                                                Text(
                                                  "4",
                                                  style: GoogleFonts.teko(
                                                      color: Colors.white),
                                                )
                                              ]),
                                              Row(children: <Widget>[
                                                Radio(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  value: 5,
                                                  groupValue: _secilenRadio,
                                                  onChanged: (value) {
                                                    setSecilenRadio(value);
                                                  },
                                                  activeColor: Colors.white,
                                                ),
                                                Text(
                                                  "4+   ",
                                                  style: GoogleFonts.teko(
                                                      color: Colors.white),
                                                )
                                              ]),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: TextFormField(
                                          controller: _rezervasyonNotu,
                                          style: GoogleFonts.teko(
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.white,
                                                            width: 0.5)),
                                            labelText: "Rezervasyon Notu",
                                            labelStyle: GoogleFonts.teko(
                                                color: Colors.white),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                            border: new OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 200,
                                              child: TextFormField(
                                                controller: _rezervasyonTarihi,
                                                validator: Validators.compose(
                                                  [
                                                    Validators.required(
                                                        "Tarih seçiniz."),
                                                  ],
                                                ),
                                                readOnly: true,
                                                style: GoogleFonts.teko(
                                                    color: Colors.white),
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0.5)),
                                                  labelText:
                                                      _secilenTarih == null
                                                          ? "Tarih Seçiniz"
                                                          : "Seçtiğiniz Tarih",
                                                  labelStyle: GoogleFonts.teko(
                                                      color: Colors.white),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Center(
                                                    child: Text(
                                                      "Tarih Seç",
                                                      style: GoogleFonts.teko(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                DateTime tarih = DateTime.now()
                                                    .add(Duration(days: 1));

                                                tarih = new DateTime(
                                                    tarih.year,
                                                    tarih.month,
                                                    tarih.day,
                                                    8,
                                                    0,
                                                    0);
                                                print(tarih);
                                                DatePicker.showDateTimePicker(
                                                    context,
                                                    showTitleActions: true,
                                                    minTime: tarih,
                                                    maxTime: tarih.add(
                                                        Duration(days: 10)),
                                                    theme: DatePickerTheme(
                                                      headerColor:
                                                          hexToColor("#A6ABAB"),
                                                      backgroundColor:
                                                          hexToColor("#3D3D3D"),
                                                      itemStyle:
                                                          GoogleFonts.roboto(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                      cancelStyle:
                                                          GoogleFonts.roboto(
                                                              color:
                                                                  Colors.black),
                                                      doneStyle:
                                                          GoogleFonts.roboto(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                    ), onChanged: (date) {
                                                  print(
                                                      'change $date in time zone ' +
                                                          date.timeZoneOffset
                                                              .inHours
                                                              .toString());
                                                }, onConfirm: (date) {
                                                  if (date.hour < 8 ||
                                                      date.hour > 21) {
                                                    BotToast.showText(
                                                        text:
                                                            "Lütfen 08:00 ile 22:00 arasında bir saat seçiniz.");
                                                  } else if (date.day <
                                                          tarih.day ||
                                                      date.day >
                                                          tarih.day + 10) {
                                                    BotToast.showText(
                                                        text:
                                                            "Bir gün sonrasından itibaren 10 gün ilerisi için rezervasyon yapabilirsiniz.");
                                                  } else {
                                                    _secilenTarih = date;
                                                    _rezervasyonTarihi
                                                        .text = DateFormat(
                                                            'yyyy-MM-dd HH:mm')
                                                        .format(_secilenTarih);
                                                    setState(() {});
                                                    print('confirm $date');
                                                  }
                                                },
                                                    currentTime: DateTime.now()
                                                        .add(
                                                            Duration(hours: 1)),
                                                    locale: LocaleType.tr);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: InkWell(
                                        child: Container(
                                          width: globals.telefonWidth - 110,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Center(
                                              child: Text(
                                                "Devam",
                                                style: GoogleFonts.teko(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          if (formKey.currentState.validate()) {
                                            globals.rezervasyonKisiSayisi =
                                                _secilenRadio.toString();
                                            globals.rezervasyonNotu =
                                                _rezervasyonNotu.text
                                                    .toString();
                                            globals.rezervasyonTarih =
                                                _secilenTarih;
                                            _getMasa();
                                            devamKontrol = true;
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
