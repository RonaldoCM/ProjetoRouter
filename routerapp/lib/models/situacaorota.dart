class SituacaoRota {
  final int id;
  final String descricao;

  SituacaoRota({required this.id, required this.descricao});

  factory SituacaoRota.fromJson(Map<String, dynamic> json) {
    return SituacaoRota(id: json['id'], descricao: json['descricao']);
  }
}
