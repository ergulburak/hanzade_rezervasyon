class Masa {
  String id;
  String qrMasano;
  String bolumid;
  bool masaRezDurumu = false;
  Masa({this.id, this.qrMasano, this.bolumid});
  factory Masa.fromJson(Map<String, dynamic> json) {
    return Masa(
        id: json['id'].toString(),
        qrMasano: json['qrMasano'].toString(),
        bolumid: json['bolumid'].toString());
  }
}
