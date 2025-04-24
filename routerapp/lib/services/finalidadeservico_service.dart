import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:routerapp/models/finalidadeservico.dart';

class FinalidadeServicoService {
  static const String baseUrl =
      'http://10.0.0.91:5251/api/Finalidade'; // Atualize com sua URL

  static Future<List<FinalidadeServico>> fetchFinalidadeServico() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((r) => FinalidadeServico.fromJson(r)).toList();
    } else {
      throw Exception('Falha ao carregar Finalidade do Serviço');
    }
  }
}
