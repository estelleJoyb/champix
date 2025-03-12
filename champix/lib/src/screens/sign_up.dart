import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:champix/src/constants/constants.dart';
class Credentials {
  final String username;
  final String password;
  final String email;

  Credentials(this.username, this.password, this.email);
}

class SignUpScreen extends StatefulWidget {
  final ValueChanged<Credentials> onSignUp;

  const SignUpScreen({required this.onSignUp, super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

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
                'Sign up',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Username'),
                controller: _usernameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: _emailController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () async {
                    widget.onSignUp(
                      Credentials(
                        _usernameController.value.text,
                        _passwordController.value.text,
                        _emailController.value.text,
                      ),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ),
              Link(
                uri: Uri.parse('/sign-in'),
                builder:
                    (context, followLink) => TextButton(
                  onPressed: followLink,
                  child: const Text('Already have an account? Sign in', style: TextStyle(color: Constants.paleGreen, decoration: TextDecoration.underline),),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}