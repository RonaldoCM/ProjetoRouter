import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:routerapp/models/endereco.dart';

class EnderecoService {
  static const String baseUrl = 'http://10.0.0.91:5251/api/Endereco';

  static Future<List<Endereco>> fetchEndereco() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((r) => Endereco.fromJson(r)).toList();
    } else {
      throw Exception('Falha ao carregar Endereços');
    }
  }
}
