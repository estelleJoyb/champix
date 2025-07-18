import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/users_service.dart';

class ChampixAuth extends ChangeNotifier {
  bool _signedIn = false;
  String? _token;
  final UsersService _usersService = UsersService();

  bool get signedIn => _signedIn;
  String? get token => _token;

  Future<void> signOut() async {
    _signedIn = false;
    _token = null;
    notifyListeners();
  }

  Future<bool> signUp(String username, String password, String email) async {
    final response = await _usersService.register(username, email, password);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return await signIn(email, password);
    }
    return false;
  }

  Future<bool> signIn(String email, String password) async {
    final response = await _usersService.login(email, password);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['access_token'];
      _signedIn = true;
      notifyListeners();
      return true;
    }
    _signedIn = false;
    _token = null;
    notifyListeners();
    return false;
  }

  @override
  bool operator ==(Object other) =>
      other is ChampixAuth && other._signedIn == _signedIn;

  @override
  int get hashCode => _signedIn.hashCode;

  static ChampixAuth of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<ChampixAuthScope>()!
          .notifier!;
}

class ChampixAuthScope extends InheritedNotifier<ChampixAuth> {
  const ChampixAuthScope({
    required super.notifier,
    required super.child,
    super.key,
  });
}