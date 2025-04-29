class PessoaFisica {
  // final int id;
  // final String codigo;
  final String nome;
  final String cpf;
  // final int ativo;
  final String? telefone;

  PessoaFisica({
    // required this.id,
    //  required this.codigo,
    required this.nome,
    required this.cpf,
    // required this.ativo,
    this.telefone,
  });

  factory PessoaFisica.fromJson(Map<String, dynamic> json) {
    return PessoaFisica(
      //  id: json['id'],
      //   codigo: json['codigo'],
      nome: json['nome'],
      cpf: json['cpf'],
      //   ativo: json['ativo'],
      telefone: json['telefone'],
    );
  }
}
