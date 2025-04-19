class Rota {
  final int id;
  final String codigo;
  final DateTime datacriacao;
  final DateTime? datafechamento;
  final String? observacao;
  final int ativo;
  final int idsituacao;

  Rota({
    required this.id,
    required this.codigo,
    required this.datacriacao,
    this.datafechamento,
    this.observacao,
    required this.ativo,
    required this.idsituacao,
  });

  factory Rota.fromJson(Map<String, dynamic> json) {
    return Rota(
      id: json['id'],
      codigo: json['codigo'],
      datacriacao: DateTime.parse(json['datacriacao']),
      datafechamento: json['datafechamento'] != null
          ? DateTime.tryParse(json['datafechamento'])
          : null,
      observacao: json['observacao'],
      ativo: json['ativo'],
      idsituacao: json['idsituacao'],
    );
  }
}