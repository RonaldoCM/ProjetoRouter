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

  static Future<List<Servico>> fetchServicosByRota(int rotaId) async {
    final url = '$baseUrl/rota/$rotaId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((r) => Servico.fromJson(r)).toList();
    } else {
      throw Exception('Falha ao carregar serviços para a rota $rotaId');
    }
  }

  static Future<bool> atualizarSituacaoServico({
    required int idServico,
    required int idSituacaoServico,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$idServico/situacao'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': idServico,
          'situacaoServicoId': idSituacaoServico,
        }),
      );

      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  static Future<Servico?> inserirServico({
    String? observacao,
    required int idfinalidade,
    required int idrota,
    required int idpessoajuridica,
    int? idPessoaFisica,
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
          'idPessoaFisica': idPessoaFisica,
        }),
      );

      if (response.statusCode == 201) {
        return Servico.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
