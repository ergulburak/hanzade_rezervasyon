import 'dart:ui';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzade_rezervasyon/Services/globals.dart' as globals;
import 'package:hanzade_rezervasyon/Services/provider.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

enum AuthMode { LOGIN, KAYIT, SIFREYENILEME, LOADING }

class LoginEkrani extends StatefulWidget {
  @override
  _LoginEkraniState createState() => _LoginEkraniState();
}

class _LoginEkraniState extends State<LoginEkrani> {
  void initState() {
    super.initState();
  }

  AuthMode _authMode = AuthMode.LOGIN;
  double _height = globals.telefonHeight * 0.45;
  double _width = globals.telefonWidth - 70;
  double _borderCircle = 40.0;

  final _emailLogin = TextEditingController();
  final _passwordLogin = TextEditingController();

  final _emailKayit = TextEditingController();
  final _passwordKayit = TextEditingController();
  final _adSoyadKayit = TextEditingController();
  final _telefonKayit = TextEditingController();
  final _passwordKontrolKayit = TextEditingController();
  final _recovery = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  String phoneNumber;
  String phoneIsoCode;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
      print(isoCode + internationalizedPhoneNumber + number);
    });
  }

  sayfa(BuildContext context) {
    if (_authMode == AuthMode.LOGIN)
      return loginMenu(context);
    else if (_authMode == AuthMode.KAYIT)
      return kayitMenu(context);
    else if (_authMode == AuthMode.SIFREYENILEME)
      return kurtarmaMenu(context);
    else if (_authMode == AuthMode.LOADING) return loading(context);
  }

  void submit() async {
    try {
      final auth = Provider.of(context).auth;
      if (_authMode == AuthMode.LOGIN) {
        _authMode = AuthMode.LOADING;
        setState(() {});
        try {
          String uid = await auth.signInWithEmailAndPassword(
              _emailLogin.text.trim(), _passwordLogin.text.trim());
          print("Signed In with ID $uid");
          Navigator.of(context).pushNamed("/karsilama");
        } catch (e) {
          BotToast.showText(text: "İşlem Başarısız!\n" + e.toString());
        }
      } else if (_authMode == AuthMode.KAYIT) {
        if (_passwordKayit.text == _passwordKontrolKayit.text) {
          _authMode = AuthMode.LOADING;
          setState(() {});
          String uid = await auth.createUserWithEmailAndPassword(
              _emailKayit.text.trim(),
              _passwordKayit.text.trim(),
              _adSoyadKayit.text.trimRight(),
              _telefonKayit.text.trim(),
              context);
          print(_telefonKayit.text.trim());
          print("Signed up with New ID $uid");
        } else {
          BotToast.showText(text: "Şifreler Uyuşmuyor");
        }
      } else {
        try {
          await auth.recovery(_recovery.text.trim());
          _authMode = AuthMode.LOGIN;
          setState(() {});
        } catch (e) {
          BotToast.showText(text: e.toString());
        }
      }
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
  }

  Widget loading(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Colors.transparent,
    );
  }

  Widget loginMenu(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.red[700]),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Giriş",
                    style: GoogleFonts.teko(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: _emailLogin,
                  keyboardType: TextInputType.visiblePassword,
                  validator: Validators.compose(
                    [
                      Validators.email('Geçersiz email.'),
                      Validators.required("Email Giriniz."),
                    ],
                  ),
                  style: GoogleFonts.teko(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.5)),
                    labelText: "Email",
                    labelStyle: GoogleFonts.teko(color: Colors.white),
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
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: _passwordLogin,
                  validator: Validators.compose(
                    [
                      Validators.required("Şifre giriniz."),
                      Validators.minLength(8, 'En az 8 karakter olmalıdır.'),
                      Validators.maxLength(
                          16, 'En fazla 16 karakter olmalıdır.'),
                      Validators.patternRegExp(
                          RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)'),
                          "Hatalı Şifre")
                    ],
                  ),
                  obscureText: true,
                  style: GoogleFonts.teko(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.5)),
                    labelText: "Şifre",
                    labelStyle: GoogleFonts.teko(color: Colors.white),
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _authMode = AuthMode.SIFREYENILEME;
                          _height = globals.telefonHeight * 0.30;
                        });
                      },
                      child: Text(
                        "Şifremi Unuttum",
                        style:
                            GoogleFonts.teko(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: InkWell(
                        onTap: () {
                          if (formKey.currentState.validate()) submit();
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
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Giriş Yap",
                              style: GoogleFonts.teko(
                                  color: Colors.black, fontSize: 26),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget kayitMenu(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.brown),
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: ListView(children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Form(
              key: formKey2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Kayıt",
                            style: GoogleFonts.teko(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                          controller: _adSoyadKayit,
                          validator: Validators.compose(
                            [
                              Validators.required("Ad Soyad giriniz."),
                              Validators.minLength(
                                  5, 'En az 3 karakter olmalıdır.'),
                            ],
                          ),
                          style: GoogleFonts.teko(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 0.5)),
                            labelText: "Ad Soyad",
                            labelStyle: GoogleFonts.teko(color: Colors.white),
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
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                          controller: _emailKayit,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.compose(
                            [
                              Validators.email('Geçersiz email.'),
                              Validators.required("Email Giriniz.")
                            ],
                          ),
                          style: GoogleFonts.teko(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 0.5)),
                            labelText: "Email",
                            labelStyle: GoogleFonts.teko(color: Colors.white),
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
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                          controller: _telefonKayit,
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(13),
                          ],
                          keyboardType: TextInputType.phone,
                          validator: Validators.compose(
                            [
                              Validators.required("Telefon numarası giriniz."),
                              Validators.minLength(
                                  13, 'En az 13 karakter olmalıdır.'),
                              Validators.maxLength(
                                  13, 'En fazla 13 karakter olmalıdır.'),
                              Validators.patternRegExp(
                                  RegExp(r'^\+[9][0][5][0-9]{9}'),
                                  "Gerekli karakterleri kullanın.")
                            ],
                          ),
                          style: GoogleFonts.teko(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 0.5)),
                            labelText: "Telefon",
                            hintText: "+905xxxxxxxxx",
                            hintStyle: GoogleFonts.teko(color: Colors.white),
                            labelStyle: GoogleFonts.teko(color: Colors.white),
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
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                          controller: _passwordKayit,
                          keyboardType: TextInputType.visiblePassword,
                          validator: Validators.compose(
                            [
                              Validators.required("Şifre giriniz."),
                              Validators.minLength(
                                  8, 'En az 8 karakter olmalıdır.'),
                              Validators.maxLength(
                                  16, 'En fazla 16 karakter olmalıdır.'),
                              Validators.patternRegExp(
                                  RegExp(
                                      r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)'),
                                  "Şifrenizde harf ve rakam bulunması gerekir.\nÖrneğin:'Deneme123'")
                            ],
                          ),
                          style: GoogleFonts.teko(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 0.5)),
                            labelText: "Şifre",
                            labelStyle: GoogleFonts.teko(color: Colors.white),
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
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                          controller: _passwordKontrolKayit,
                          keyboardType: TextInputType.visiblePassword,
                          validator: Validators.compose(
                            [
                              Validators.required("Şifre giriniz."),
                              Validators.minLength(
                                  8, 'En az 8 karakter olmalıdır.'),
                              Validators.maxLength(
                                  16, 'En fazla 16 karakter olmalıdır.'),
                              Validators.patternRegExp(
                                  RegExp(
                                      r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)'),
                                  "Gerekli karakterleri kullanın.")
                            ],
                          ),
                          style: GoogleFonts.teko(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 0.5)),
                            labelText: "Şifre Kontrol",
                            labelStyle: GoogleFonts.teko(color: Colors.white),
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: InkWell(
                                  onTap: () {
                                    _authMode = AuthMode.LOGIN;
                                    _height = globals.telefonHeight * 0.45;
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "Geri",
                                        style: GoogleFonts.teko(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: InkWell(
                                  onTap: () {
                                    if (formKey2.currentState.validate())
                                      submit();
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
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "Giriş Yap",
                                        style: GoogleFonts.teko(
                                            color: Colors.black, fontSize: 26),
                                      ),
                                    ),
                                  )),
                            ),
                          ]),
                    ),
                    SizedBox(height: 20)
                  ]),
            ),
          ]),
        ));
  }

  Widget kurtarmaMenu(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.red[700]),
        child: Form(
          key: formKey3,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Şifremi Kurtar",
                        style: GoogleFonts.teko(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w400)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      controller: _recovery,
                      validator: Validators.compose(
                        [
                          Validators.email('Geçersiz email.'),
                          Validators.required("Email Giriniz."),
                        ],
                      ),
                      style: GoogleFonts.teko(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 0.5)),
                        labelText: "Email",
                        labelStyle: GoogleFonts.teko(color: Colors.white),
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
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: InkWell(
                            onTap: () {
                              _authMode = AuthMode.LOGIN;
                              _height = globals.telefonHeight * 0.45;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Geri",
                                  style: GoogleFonts.teko(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: InkWell(
                            onTap: () {
                              if (formKey3.currentState.validate()) {
                                submit();
                                _height = globals.telefonHeight * 0.45;
                              }
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
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Kurtar",
                                  style: GoogleFonts.teko(
                                      color: Colors.black, fontSize: 26),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
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
                      : _authMode == AuthMode.KAYIT
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
                                      image: new ExactAssetImage(
                                          'assets/logo.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 700),
                        curve: Curves.fastOutSlowIn,
                        decoration: BoxDecoration(
                            color: /*hexToColor("#3D3D3D")*/ Colors.black
                                .withOpacity(0.00),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(_borderCircle),
                                topRight: Radius.circular(_borderCircle),
                                bottomLeft: Radius.circular(_borderCircle),
                                bottomRight: Radius.circular(_borderCircle))),
                        height: _height,
                        width: _width,
                        //width: MediaQuery.of(context).size.width - 10,
                        alignment: Alignment.center,
                        child: sayfa(context),
                      ),
                    ),
                  ),
                  _authMode != AuthMode.KAYIT
                      ? MediaQuery.of(context).viewInsets.bottom != 0
                          ? Container()
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Hala üye değil misin?",
                                        style: GoogleFonts.teko(
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        child: Text("Üye ol",
                                            style: GoogleFonts.teko(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.underline,
                                            )),
                                        onTap: () {
                                          _authMode = AuthMode.KAYIT;
                                          _height =
                                              globals.telefonHeight * 0.78;
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                      : Container()
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
