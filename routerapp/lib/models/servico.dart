class Servico {
  final int id;
  final DateTime datacriacao;
  final DateTime? datafechamento;
  final String situacao;
  final String finalidade;
  final String codigoRota;
  final String nomePessoaJuridica;
  final String? observacao;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;

  Servico({
    required this.id,
    required this.datacriacao,
    this.datafechamento,
    required this.situacao,
    required this.finalidade,
    required this.codigoRota,
    required this.nomePessoaJuridica,
    this.observacao,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'],
      datacriacao: DateTime.parse(json['datacriacao']),
      datafechamento:
          json['datafechamento'] != null
              ? DateTime.parse(json['datafechamento'])
              : null,
      situacao: json['situacao'],
      finalidade: json['finalidade'],
      codigoRota: json['codigoRota'],
      nomePessoaJuridica: json['nomePessoaJuridica'],
      observacao: json['observacao'],
      logradouro: json['logradouro'],
      numero: json['numero'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
    );
  }
}
