import 'dart:async';
import 'dart:convert';
import 'package:hanzade_rezervasyon/Services/tablo/masa.dart';
import 'package:hanzade_rezervasyon/Services/tablo/rezervasyon.dart';
import 'package:http/http.dart' as http;

class Services {
  static const ROOT = 'https://hanzade.live/Classes/Util/RezervasyonApp.php';

  static const _GET_MASA_ALL_ACTION = 'GET_MASA_ALL';
  static const _GET_MASA_BILGI_ACTION = 'MASA_BILGI';
  static const _GET_REZERVASYON_ALL_BY_TARIH_ACTION =
      'REZERVASYON_ALL_BY_TARIH';
  static const _GET_REZERVASYONUMU_GETIR_ACTION = 'REZERVASYONUMU_GETIR';

  static const _SET_INSERT_TOKEN_ACTION = 'INSERT_TOKEN';

  static const _ADD_REZERVASYON_KAYIT_ACTION = 'REZERVASYON_KAYIT';

  static const _DEL_REZERVASYONU_SIL_ACTION = 'REZERVASYONU_SIL';
/*
  ****************************************************************************
  ****************************************************************************05326026538
  ****************************************************************************
                              Çağırma metodları
  ****************************************************************************
  ****************************************************************************
  ****************************************************************************
*/

  static Future<List<Masa>> getMasa() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_MASA_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getMASA: ${response.body}');
      if (200 == response.statusCode) {
        List<Masa> list = parseResponseMasa(response.body);
        return list;
      } else {
        return List<Masa>();
      }
    } catch (e) {
      print("aha burası sıkıntıMasa" + e.toString());
      return List<Masa>();
    }
  }

  static Future<List<Rezervasyon>> getRezervasyonAllByTarih(
      String tarih) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_REZERVASYON_ALL_BY_TARIH_ACTION;
      map['tarih'] = tarih;
      final response = await http.post(ROOT, body: map);
      print('Gelen rezervasyonlar: ${response.body}');
      if (200 == response.statusCode) {
        List<Rezervasyon> list = parseResponseRezervasyon(response.body);
        return list;
      } else {
        return List<Rezervasyon>();
      }
    } catch (e) {
      print("RABT Catch Hatası:" + e.toString());
      return List<Rezervasyon>();
    }
  }

  static Future<List<Rezervasyon>> getRezervasyonumuGetir(String email) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_REZERVASYONUMU_GETIR_ACTION;
      map['eposta'] = email;
      final response = await http.post(ROOT, body: map);
      print('Gelen rezervasyonum: ${response.body}');
      if (200 == response.statusCode) {
        if (response.body == "boş") {
          return List<Rezervasyon>();
        }
        List<Rezervasyon> list = parseResponseRezervasyon(response.body);
        return list;
      } else {
        return List<Rezervasyon>();
      }
    } catch (e) {
      print("RG Catch Hatası:" + e.toString());
      return List<Rezervasyon>();
    }
  }

  static Future<String> masaBilgi(String masaid) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_MASA_BILGI_ACTION;
      map['masaid'] = masaid;
      final response = await http.post(ROOT, body: map);
      print('Masa bilgi: ${response.body}' + " id=" + masaid);
      if (200 == response.statusCode) {
        String list = response.body;
        return list;
      } else {
        return "NULL";
      }
    } catch (e) {
      print("MasaBilgi Hata: " + e);
      return "NULL";
    }
  }

  /*
  ****************************************************************************
  ****************************************************************************
  ****************************************************************************
                              Güncelleme metodları
  ****************************************************************************
  ****************************************************************************
  ****************************************************************************
*/

  static Future<String> tokenInsert(String kayitId, String ip) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _SET_INSERT_TOKEN_ACTION;
      map['kayitId'] = kayitId;
      map['ip'] = ip;
      final response = await http.post(ROOT, body: map);
      print('Token sonuç: ${response.body}' + " id=" + kayitId);
      if (200 == response.statusCode) {
        String list = response.body;
        return list;
      } else {
        return "NULL";
      }
    } catch (e) {
      print("MasaBilgi Hata: " + e);
      return "NULL";
    }
  }

  /*
  ****************************************************************************
  ****************************************************************************
  ****************************************************************************
                              Ekleme metodları
  ****************************************************************************
  ****************************************************************************
  ****************************************************************************
*/

  static Future<String> addRezervasyon(
    String ad,
    String telefon,
    String eposta,
    String kisiSayisi,
    String notu,
    String masaNo,
    String tarih,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_REZERVASYON_KAYIT_ACTION;
      map['ad'] = ad;
      map['telefon'] = telefon;
      map['eposta'] = eposta;
      map['kisi_sayisi'] = kisiSayisi;
      map['not'] = notu;
      map['masa'] = masaNo;
      map['tarih'] = tarih;
      final response = await http.post(ROOT, body: map);
      print('Ekleme işlemi: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "Sunucuda işlem başarısız.";
      }
    } catch (e) {
      print("Catch hatası: " + e);
      return "Catch HATASI";
    }
  }

  /*
  ****************************************************************************
  ****************************************************************************
  ****************************************************************************
                              Silme metodları
  ****************************************************************************
  ****************************************************************************
  ****************************************************************************
*/
  static Future<String> rezervasyonSil(String rezId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DEL_REZERVASYONU_SIL_ACTION;
      map['id'] = rezId;
      final response = await http.post(ROOT, body: map);
      print('Sonuç: ${response.body}');
      if (200 == response.statusCode) {
        String list = response.body;
        return list;
      } else {
        return "NULL";
      }
    } catch (e) {
      print("Silme Hata: " + e);
      return "NULL";
    }
  }

/*
  ****************************************************************************
  ****************************************************************************
  ****************************************************************************
                              Dönüştürme metodları
  ****************************************************************************
  ****************************************************************************
  ****************************************************************************
*/

  static List<Masa> parseResponseMasa(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Masa>((json) => Masa.fromJson(json)).toList();
  }

  static List<Rezervasyon> parseResponseRezervasyon(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<Rezervasyon>((json) => Rezervasyon.fromJson(json))
        .toList();
  }
}
