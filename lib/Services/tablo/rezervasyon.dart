class Rezervasyon {
  String id;
  String rezervasyonAd;
  String rezervasyonTelefon;
  String rezervasyonEposta;
  String rezervasyonKisiSayisi;
  String rezervasyonNotu;
  String rezervasyonMasa;
  String rezervasyonTarih;
  String rezervasyonOlusturulmaZamani;
  Rezervasyon({
    this.id,
    this.rezervasyonAd,
    this.rezervasyonTelefon,
    this.rezervasyonEposta,
    this.rezervasyonKisiSayisi,
    this.rezervasyonNotu,
    this.rezervasyonMasa,
    this.rezervasyonTarih,
    this.rezervasyonOlusturulmaZamani,
  });
  factory Rezervasyon.fromJson(Map<String, dynamic> json) {
    return Rezervasyon(
        id: json['id'].toString(),
        rezervasyonAd: json['rezervasyon_ad'].toString(),
        rezervasyonTelefon: json['rezervasyon_telefon'].toString(),
        rezervasyonEposta: json['rezervasyon_eposta'].toString(),
        rezervasyonKisiSayisi: json['rezervasyon_kisi_sayisi'].toString(),
        rezervasyonNotu: json['rezervasyon_notu'].toString(),
        rezervasyonMasa: json['rezervasyon_masa'].toString(),
        rezervasyonTarih: json['rezervasyon_tarih'].toString(),
        rezervasyonOlusturulmaZamani:
            json['rezervasyon_olusturulma_zamanı'].toString());
  }
}
