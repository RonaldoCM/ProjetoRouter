class PessoaFisica {
  final int? id;
  final String nome;
  final String cpf;
  final String? telefone;

  PessoaFisica({this.id, required this.nome, required this.cpf, this.telefone});

  factory PessoaFisica.fromJson(Map<String, dynamic> json) {
    return PessoaFisica(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      telefone: json['telefone'],
    );
  }
}
