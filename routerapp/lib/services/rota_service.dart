import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rota.dart';

class RotaService {
  static const String baseUrl =
      'http://10.0.0.91:5251/api/Rota'; // Atualize com sua URL

  static Future<List<Rota>> fetchRotas() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((r) => Rota.fromJson(r)).toList();
    } else {
      throw Exception('Falha ao carregar rotas');
    }
  }

  static Future<Rota> fetchRotaById(int rotaId) async {
    final url = '$baseUrl/$rotaId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Rota.fromJson(jsonResponse); //usa Rota.fromJson diretamente
    } else {
      throw Exception('Falha ao carregar a Rota');
    }
  }

  static Future<Rota?> criarRota(String? observacao) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{'observacao': observacao}),
      );

      if (response.statusCode == 201) {
        return Rota.fromJson(jsonDecode(response.body));
      } else {
        // print('Erro ao criar rota: ${response.statusCode}');
        // print('Corpo da resposta: ${response.body}');
        return null;
      }
    } catch (e) {
      //('Erro de conexão ao criar rota: $e');
      return null;
    }
  }

  static Future<bool> atualizarSituacaoRota({
    required int idRota,
    required int idSituacaoRota,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$idRota/rota'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': idRota,
          'situacaoRotaId': idSituacaoRota,
          'observacao': null,
          'ativo': 1,
        }),
      );

      return response.statusCode == 204; // NoContent indica sucesso
    } catch (e) {
      return false;
    }
  }
}
