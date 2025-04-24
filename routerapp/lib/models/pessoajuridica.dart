class PessoaJuridica {
  final int id;
  final String codigo;
  final String nome;
  final String cnpj;
  final int ativo;
  final int idendereco;
  final String? telefone;

  PessoaJuridica({
    required this.id,
    required this.codigo,
    required this.nome,
    required this.cnpj,
    required this.ativo,
    required this.idendereco,
    this.telefone,
  });

  factory PessoaJuridica.fromJson(Map<String, dynamic> json) {
    return PessoaJuridica(
      id: json['id'],
      codigo: json['codigo'],
      nome: json['nome'],
      cnpj: json['cnpj'],
      ativo: json['ativo'],
      idendereco: json['idendereco'],
      telefone: json['telefone'],
    );
  }
}
