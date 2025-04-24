import 'dart:convert';
import 'package:http/http.dart' as http;
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
}
