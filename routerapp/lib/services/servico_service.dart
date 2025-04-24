import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:routerapp/models/servico.dart';

class ServicoService {
  static const String baseUrl = 'http://10.0.0.91:5251/api/Servico';

  static Future<List<Servico>> fetchServicos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((r) => Servico.fromJson(r)).toList();
    } else {
      throw Exception('Falha ao carregar Serviços');
    }
  }
}
