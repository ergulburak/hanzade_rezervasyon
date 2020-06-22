import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzade_rezervasyon/Services/tablo/feedback.dart';
import 'package:hanzade_rezervasyon/Services/globals.dart' as globals;
import 'package:wc_form_validators/wc_form_validators.dart';

class GeriBildirim extends StatefulWidget {
  @override
  _GeriBildirimState createState() => _GeriBildirimState();
}

class _GeriBildirimState extends State<GeriBildirim> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _baslik = TextEditingController();
  final _bildiri = TextEditingController();

  final formKey = GlobalKey<FormState>();

  geriBildir() async {
    GeriBildirimTablo geriBildirim = new GeriBildirimTablo();
    _firebaseAuth.currentUser().then((value) async {
      geriBildirim.email = value.email;
      geriBildirim.baslik = _baslik.text;
      geriBildirim.bildiri = _bildiri.text;
      await _db
          .collection("feedbacks")
          .add(geriBildirim.toJson())
          .then((value) {
        BotToast.showText(
          text: "Geri Bildiriminiz için Teşekkür Ederiz.",
          duration: Duration(seconds: 5),
        );
        Navigator.pushNamed(context, "/karsilama");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
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
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              validator: Validators.compose(
                                [
                                  Validators.required("Başlık giriniz."),
                                ],
                              ),
                              controller: _baslik,
                              style: GoogleFonts.teko(color: Colors.white),
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 0.5),
                                ),
                                labelText: "Başlık",
                                labelStyle:
                                    GoogleFonts.teko(color: Colors.white),
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
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: Validators.compose(
                                [
                                  Validators.required("Bildirimi giriniz."),
                                ],
                              ),
                              controller: _bildiri,
                              maxLines: 6,
                              maxLength: 1000,
                              keyboardType: TextInputType.multiline,
                              style: GoogleFonts.teko(color: Colors.white),
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 0.5),
                                ),
                                labelText: "Geri Bildirim",
                                labelStyle:
                                    GoogleFonts.teko(color: Colors.white),
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
                            InkWell(
                              onTap: () {
                                if (formKey.currentState.validate()) {
                                  geriBildir();
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
                                width: globals.telefonWidth - 40,
                                height: 50,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Text(
                                        "Gönder",
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
                      ),
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
}
