class Servico {
  final int id;
  final DateTime datacriacao;
  final DateTime? datafechamento;
  final String? observacao;
  final int idsituacaoservico;
  final int idfinalidade;
  final int idrota;
  final int idpessoajuridica;

  Servico({
    required this.id,
    required this.datacriacao,
    this.datafechamento,
    this.observacao,
    required this.idsituacaoservico,
    required this.idfinalidade,
    required this.idrota,
    required this.idpessoajuridica,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'],
      datacriacao: json['datacriacao'],
      datafechamento: json['datafechamento'],
      observacao: json['observacao'],
      idsituacaoservico: json['situacaoservicoid'],
      idfinalidade: json['finalidadeid'],
      idrota: json['rotaid'],
      idpessoajuridica: json['pessoajuridicaid'],
    );
  }
}
