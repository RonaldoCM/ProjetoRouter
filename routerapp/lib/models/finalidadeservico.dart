class FinalidadeServico {
  final int id;
  final String descricao;

  FinalidadeServico({required this.id, required this.descricao});

  factory FinalidadeServico.fromJson(Map<String, dynamic> json) {
    return FinalidadeServico(id: json['id'], descricao: json['descricao']);
  }
}
