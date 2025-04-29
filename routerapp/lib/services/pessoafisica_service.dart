import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:routerapp/models/pessoafisica.dart';

class PessoaFisicaService {
  static const String baseUrl = 'http://10.0.0.91:5251/api/Pessoafisica';

  static Future<List<PessoaFisica>> fetchPessoaFisica() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((r) => PessoaFisica.fromJson(r)).toList();
    } else {
      throw Exception('Falha ao carregar colaborador');
    }
  }

  static Future<PessoaFisica?> inserirPessoaFisica({
    required String nome,
    required String cpf,
    String? telefone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nome': nome,
          'cpf': cpf,
          'telefone': telefone,
        }),
      );

      if (response.statusCode == 201) {
        return PessoaFisica.fromJson(jsonDecode(response.body));
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
