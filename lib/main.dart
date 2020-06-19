import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanzade_rezervasyon/Services/authServices.dart';
import 'package:hanzade_rezervasyon/Services/provider.dart';
import 'package:hanzade_rezervasyon/Services/sayfaYonlendirici.dart';
import 'package:hanzade_rezervasyon/Services/globals.dart' as globals;

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }
}

class BeklemeSayfasi extends StatelessWidget {
  const BeklemeSayfasi({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Provider(
        auth: AuthService(),
        child: new MaterialApp(
          onGenerateRoute: RouteGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
          home: new Scaffold(
            backgroundColor: Colors.transparent,
            body: MyHomePage(),
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _handleStartScreen();
  }

  Future<void> _handleStartScreen() async {
    AuthService _auth = AuthService();
    if (await _auth.isLoggedIn()) {
      Future.delayed(const Duration(seconds: 3),
          () => Navigator.pushNamed(context, "/karsilama"));
    } else {
      Future.delayed(const Duration(seconds: 3),
          () => Navigator.pushNamed(context, "/login"));
    }
  }

  @override
  Widget build(BuildContext context) {
    globals.telefonHeight = MediaQuery.of(context).size.height;
    globals.telefonWidth = MediaQuery.of(context).size.width;
    return girisEkrani();
    /*StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.providerData.length == 1)
              return Anasayfa();
            else {
              Navigator.pushNamed(context, "/login");
              return null;
            }
          } else {
            Navigator.pushNamed(context, "/login");
            return null;
          }
        });*/
  }

  Scaffold girisEkrani() {
    return Scaffold(
      backgroundColor: Colors.amber,
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
          Align(
            alignment: Alignment.center,
            child:
                CircularProgressIndicator(backgroundColor: Colors.transparent),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Hanzade\nRezervasyon",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
