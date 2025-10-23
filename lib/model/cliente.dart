class Cliente {
  int? codigo;
  String cpf;
  String nome;
  int idade;
  String dataNascimento;
  int? cidadeId;
  String cidadeNascimento;

  Cliente({
    this.codigo,
    required this.cpf,
    required this.nome,
    required this.idade,
    required this.dataNascimento,
    this.cidadeId,
    required this.cidadeNascimento,
  });

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'cpf': cpf,
      'nome': nome,
      'idade': idade,
      'dataNascimento': dataNascimento,
      'cidadeNascimento': cidadeNascimento,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      codigo: map['codigo'],
      cpf: map['cpf'],
      nome: map['nome'],
      idade: map['idade'],
      dataNascimento: map['dataNascimento'],
      cidadeNascimento: map['cidadeNascimento'],
    );
  }
}
