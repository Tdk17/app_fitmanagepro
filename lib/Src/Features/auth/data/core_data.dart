class BrCity {
  final String name;
  final String uf;

  const BrCity({required this.name, required this.uf});

  String get label => "$name - $uf";

  Map<String, dynamic> toJson() => {"name": name, "uf": uf};

  static BrCity fromJson(Map<String, dynamic> j) => BrCity(
    name: (j["name"] ?? "").toString(),
    uf: (j["uf"] ?? "").toString(),
  );

  static BrCity fromIbge(Map<String, dynamic> m) {
    final name = (m['nome'] ?? '').toString();
    final uf =
        (((m['microrregiao'] ?? {})['mesorregiao'] ?? {})['UF'] ?? {})['sigla'];
    return BrCity(name: name, uf: (uf ?? '').toString());
  }
}
