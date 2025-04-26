class Servico {
  final int id;
  final DateTime datacriacao;
  final DateTime? datafechamento;
  final String situacao;
  final String finalidade;
  final String codigoRota;
  final String nomePessoaJuridica;
  final String? observacao;

  Servico({
    required this.id,
    required this.datacriacao,
    this.datafechamento,
    required this.situacao,
    required this.finalidade,
    required this.codigoRota,
    required this.nomePessoaJuridica,
    this.observacao,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'],
      datacriacao: DateTime.parse(json['datacriacao']),
      datafechamento:
          json['datafechamento'] != null
              ? DateTime.parse(json['datafechamento'])
              : null, // Converter String para DateTime se não for nulo
      situacao: json['situacao'],
      finalidade: json['finalidade'],
      codigoRota: json['codigoRota'],
      nomePessoaJuridica: json['nomePessoaJuridica'],
      observacao: json['observacao'],
    );
  }
}
