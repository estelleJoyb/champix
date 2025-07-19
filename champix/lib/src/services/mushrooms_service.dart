import 'dart:convert';
import 'package:http/http.dart' as http;

class MushroomService {
  final String baseUrl;
  static String? _token;

  MushroomService({this.baseUrl = "http://localhost:8000"});

  static void setToken(String token) {
    _token = token;
  }

  Future<List<dynamic>> getAllMushrooms() async {
    if (_token == null) throw Exception("Token manquant");

    final url = Uri.parse('$baseUrl/mushrooms/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      return jsonDecode(decoded);
    } else {
      throw Exception("Erreur lors de la récupération des champignons");
    }
  }

  Future<Map<String, dynamic>> getMushroomById(String id) async {
    if (_token == null) throw Exception("Token manquant");

    final url = Uri.parse('$baseUrl/mushrooms/$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      return jsonDecode(decoded);
    } else {
      throw Exception("Erreur lors de la récupération du champignon");
    }
  }

  Future<Map<String, dynamic>> createMushroom(
      Map<String, dynamic> mushroomData) async {
    if (_token == null) throw Exception("Token manquant");

    final url = Uri.parse('$baseUrl/mushrooms/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(mushroomData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors de la création du champignon");
    }
  }

  Future<Map<String, dynamic>> updateMushroom(
      int id, Map<String, dynamic> mushroomData) async {
    if (_token == null) throw Exception("Token manquant");

    final url = Uri.parse('$baseUrl/mushrooms/$id');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(mushroomData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors de la mise à jour du champignon");
    }
  }

  Future<void> deleteMushroom(int id) async {
    if (_token == null) throw Exception("Token manquant");

    final url = Uri.parse('$baseUrl/mushrooms/$id');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la suppression du champignon");
    }
  }
}
