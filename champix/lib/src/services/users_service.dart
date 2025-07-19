import 'dart:convert';
import 'package:http/http.dart' as http;

class UsersService {
  final String baseUrl;
  static String? _token;

  UsersService({this.baseUrl = "http://localhost:8000"});

  static void setToken(String token) {
    _token = token;
  }


  Future<http.Response> register(String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/users/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email.toLowerCase(),
        'password': password,
      }),
    );
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/token');
    final emailLower = email.toLowerCase();
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'username=$emailLower&password=$password',
    );
    return response;
  }

  Future<http.Response> getUserHistory() async {
    if (_token == null) {
      throw Exception("Utilisateur non authentifié : token manquant");
    }
    final url = Uri.parse('$baseUrl/users/history');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    return response;
  }
  
  Future<Map<String, dynamic>> getCurrentUser() async {
    if (_token == null) {
      throw Exception("Utilisateur non authentifié : token manquant");
    }
    final url = Uri.parse('$baseUrl/users/me');
    
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors de la récupération du profil utilisateur");
    }
  }
}