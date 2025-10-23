class Cidade {
  int? id;
  String nomeCidade;
  // String estado;

  Cidade({
    this.id,
    required this.nomeCidade,
    // required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeCidade': nomeCidade,
      // 'estado': estado,
    };
  }

  factory Cidade.fromMap(Map<String, dynamic> map) {
    return Cidade(
      id: map['id'],
      nomeCidade: map['nomeCidade'],
      // estado: map['estado'],
    );
  }
}
