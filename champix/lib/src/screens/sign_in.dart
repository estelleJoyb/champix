import 'package:champix/src/services/mushroom_ai_service.dart';
import 'package:champix/src/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';
import 'package:champix/src/constants/constants.dart';
import 'package:champix/src/auth.dart';

class Credentials {
  final String username;
  final String password;

  Credentials(this.username, this.password);
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  Future<void> _handleSignIn() async {
    final auth = ChampixAuth.of(context);

    final success = await auth.signIn(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return; 

    if (!success) {
      setState(() {
        _error = "Invalid email or password";
      });
    } else {
      setState(() {
        _error = null;
      });
      MushroomAIService.setToken(auth.token!);
      UsersService.setToken(auth.token!);
      GoRouter.of(context).go('/champignon');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Card(
        child: Container(
          constraints: BoxConstraints.loose(const Size(600, 600)),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sign in',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: _usernameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _handleSignIn,
                  child: const Text('Sign in'),
                ),
              ),
              Link(
                uri: Uri.parse('/sign-up'),
                builder: (context, followLink) => TextButton(
                  onPressed: followLink,
                  child: const Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(
                      color: Constants.paleGreen,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}