import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rota.dart';

class RotaService {
  static const String baseUrl = 'http://10.0.0.91:5251/api/Rota'; // Atualize com sua URL

  static Future<List<Rota>> fetchRotas() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((r) => Rota.fromJson(r)).toList();
    } else {
      throw Exception('Falha ao carregar rotas');
    }
  }
}
