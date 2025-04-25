class Endereco {
  final int id;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final int ativo;

  Endereco({
    required this.id,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.ativo,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      id: json['id'],
      logradouro: json['logradouro'],
      numero: json['numero'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
      ativo: json['ativo'],
    );
  }
}
