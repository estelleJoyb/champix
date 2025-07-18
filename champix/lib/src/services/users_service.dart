import 'dart:convert';
import 'package:http/http.dart' as http;

class UsersService {
  final String baseUrl;

  UsersService({this.baseUrl = "http://localhost:8000"});

  Future<http.Response> register(String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/users/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/token');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'username=$email&password=$password',
    );
    return response;
  }
}