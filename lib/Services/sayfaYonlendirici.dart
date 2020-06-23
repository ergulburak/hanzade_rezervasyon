import 'package:flutter/material.dart';
import 'package:hanzade_rezervasyon/Pages/Rezervasyon/bilgiGirisi.dart';
import 'package:hanzade_rezervasyon/Pages/Rezervasyon/masaSecimi.dart';
import 'package:hanzade_rezervasyon/Pages/Rezervasyon/rezOnizleme.dart';
import 'package:hanzade_rezervasyon/Pages/feedback.dart';
import 'package:hanzade_rezervasyon/Pages/karsilama.dart';
import 'package:hanzade_rezervasyon/Pages/login.dart';
import 'package:hanzade_rezervasyon/Pages/rezervasyonlarim.dart';

import '../main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BeklemeSayfasi());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginEkrani());
      case '/karsilama':
        return MaterialPageRoute(builder: (_) => KarsilamaEkran());
      case '/bilgigirisi':
        return MaterialPageRoute(builder: (_) => BilgiGirisSayfasi());
      case '/masasecimi':
        return MaterialPageRoute(builder: (_) => MasaSecimi());
      case '/geribildirim':
        return MaterialPageRoute(builder: (_) => GeriBildirim());
      case '/rezlerim':
        return MaterialPageRoute(builder: (_) => Rezervasyonlarim());
      case '/rezonizleme':
        return MaterialPageRoute(
            builder: (_) => RezervasyonOnizleme(
                  user: args,
                ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Hata"),
        ),
        body: Center(
          child: Text("Bir şey oldu."),
        ),
      );
    });
  }
}
