class SituacaoServico {
  final int id;
  final String descricao;

  SituacaoServico({required this.id, required this.descricao});

  factory SituacaoServico.fromJson(Map<String, dynamic> json) {
    return SituacaoServico(id: json['id'], descricao: json['descricao']);
  }
}
