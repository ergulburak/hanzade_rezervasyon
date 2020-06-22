class GeriBildirimTablo {
  String email;
  String bildiri;
  String baslik;

  GeriBildirimTablo({
    this.email,
    this.bildiri,
    this.baslik,
  });

  GeriBildirimTablo.fromMap(Map snapshot, String mail)
      : email = mail ?? '',
        bildiri = snapshot['bildiri'] ?? '',
        baslik = snapshot['baslik'] ?? '';

  toJson() {
    return {
      "email": email,
      "bildiri": bildiri,
      "baslik": baslik,
    };
  }
}
