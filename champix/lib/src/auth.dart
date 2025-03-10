
import 'package:flutter/widgets.dart';

/// A mock authentication service
class ChampixAuth extends ChangeNotifier {
  bool _signedIn = false;

  bool get signedIn => _signedIn;

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Sign out.
    _signedIn = false;
    notifyListeners();
  }

  Future<bool> signUp(String username, String password, String email) async {
    //todo create account
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Sign in. Allow any password.
    _signedIn = true;
    notifyListeners();
    return _signedIn;
  }

  Future<bool> signIn(String username, String password) async {
    //todo sign in
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Sign in. Allow any password.
    _signedIn = true;
    notifyListeners();
    return _signedIn;
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