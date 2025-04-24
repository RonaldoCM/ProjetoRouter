import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:routerapp/models/situacaoRota.dart';

class SituacaoRotaService {
  static const String baseUrl =
      'http://10.0.0.91:5251/api/SituacaoServico'; // Atualize com sua URL

  static Future<List<SituacaoRota>> fetchSituacaoRota() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((r) => SituacaoRota.fromJson(r)).toList();
    } else {
      throw Exception('Falha ao carregar Situação da Rota');
    }
  }
}
