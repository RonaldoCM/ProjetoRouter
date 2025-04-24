import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:routerapp/models/situacaoservico.dart';

class SituacaoServicoService {
  static const String baseUrl =
      'http://10.0.0.91:5251/api/SituacaoServico'; // Atualize com sua URL

  static Future<List<SituacaoServico>> fetchSituacaoServico() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((r) => SituacaoServico.fromJson(r)).toList();
    } else {
      throw Exception('Falha ao carregar Situação do Serviço');
    }
  }
}
