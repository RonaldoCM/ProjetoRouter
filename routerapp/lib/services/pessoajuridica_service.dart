import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:routerapp/models/pessoafisica.dart';
import 'package:routerapp/models/pessoajuridica.dart';

class PessoaJuridicaService {
  static const String baseUrl =
      'http://10.0.0.91:5251/api/Pessoajuridica'; // Atualize com sua URL

  static Future<List<PessoaJuridica>> fetchPessoaJuridica() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((r) => PessoaJuridica.fromJson(r)).toList();
    } else {
      throw Exception('Falha ao carregar Pessoa Jurídica');
    }
  }

  static Future<PessoaJuridica?> inserirPessoaJuridica({
    required String nome,
    required String cnpj,
    String? telefone,
    required endereco,
    required List<PessoaFisica> pessoasFisicas,
  }) async {
    try {
      // Formatar a lista de PessoaFisica para o formato esperado pela API
      List<Map<String, dynamic>> pessoaFisicaListJson =
          pessoasFisicas
              .map(
                (pf) => {
                  'Nome': pf.nome,
                  'Cpf': pf.cpf,
                  'Telefone': pf.telefone,
                },
              )
              .toList();

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nome': nome,
          'cnpj': cnpj,
          'telefone': telefone,
          'endereco': {
            'logradouro': endereco.logradouro,
            'numero': endereco.numero,
            'bairro': endereco.bairro,
            'cidade': endereco.cidade,
            'estado': endereco.estado,
          },
          'pessoafisica': pessoaFisicaListJson,
        }),
      );

      if (response.statusCode == 201) {
        return PessoaJuridica.fromJson(jsonDecode(response.body));
      } else {
        // print('Erro ao inserir Pessoa Jurídica: ${response.statusCode}');
        // print('Corpo da resposta: ${response.body}');
        return null;
      }
    } catch (e) {
      //print('Erro de conexão ao inserir Pessoa Jurídica: $e');
      return null;
    }
  }
}
