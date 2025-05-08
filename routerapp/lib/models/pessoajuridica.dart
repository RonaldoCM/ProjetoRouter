import 'package:routerapp/models/pessoafisica.dart';

class PessoaJuridica {
  final int id;
  final String codigo;
  final String nome;
  final String cnpj;
  final int ativo;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final String? telefone;
  final List<PessoaFisica>? pessoasFisicas;

  PessoaJuridica({
    required this.id,
    required this.codigo,
    required this.nome,
    required this.cnpj,
    required this.ativo,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.telefone,
    this.pessoasFisicas,
  });

  factory PessoaJuridica.fromJson(Map<String, dynamic> json) {
    // Extrai o objeto 'endereco' do JSON
    final enderecoJson = json['endereco'] ?? {};

    return PessoaJuridica(
      id: json['id'],
      codigo: json['codigo'],
      nome: json['nome'],
      cnpj: json['cnpj'],
      ativo: json['ativo'],
      // Extrai os campos do endereço diretamente
      logradouro: enderecoJson['logradouro'] ?? '',
      numero: enderecoJson['numero'] ?? '',
      bairro: enderecoJson['bairro'] ?? '',
      cidade: enderecoJson['cidade'] ?? '',
      estado: enderecoJson['estado'] ?? '',
      telefone: json['telefone'],
      pessoasFisicas:
          (json['pessoasFisicas'] as List<dynamic>?)
              ?.map((pfJson) => PessoaFisica.fromJson(pfJson))
              .toList(),
    );
  }
}
