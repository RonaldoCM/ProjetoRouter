import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:routerapp/models/servico.dart';

class ServicoService {
  static const String baseUrl = 'http://10.0.0.91:5251/api/Servicos';

  static Future<List<Servico>> fetchServicos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((r) => Servico.fromJson(r)).toList();
    } else {
      throw Exception('Falha ao carregar Serviços');
    }
  }

  static Future<Servico?> inserirServico({
    String? observacao,
    required int idfinalidade,
    required int idrota,
    required int idpessoajuridica,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'observacao': observacao,
          'FinalidadeId': idfinalidade,
          'RotaId': idrota,
          'PessoajuridicaId': idpessoajuridica,
        }),
      );

      // print('Status Code: ${response.statusCode}');
      // print('Headers: ${response.headers}'); // <--- Verifique isso
      // print('Body: ${response.body}');

      if (response.statusCode == 201) {
        return Servico.fromJson(jsonDecode(response.body));
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
