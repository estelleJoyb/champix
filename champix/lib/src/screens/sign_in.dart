import 'package:url_launcher/link.dart';
import 'package:flutter/material.dart';
import 'package:champix/src/constants/constants.dart';

class Credentials {
  final String username;
  final String password;

  Credentials(this.username, this.password);
}

class SignInScreen extends StatefulWidget {
  final ValueChanged<Credentials> onSignIn;

  const SignInScreen({required this.onSignIn, super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
              TextField(
                decoration: const InputDecoration(labelText: 'Username'),
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
                  onPressed: () async {
                    widget.onSignIn(
                      Credentials(
                        _usernameController.value.text,
                        _passwordController.value.text,
                      ),
                    );
                  },
                  child: const Text('Sign in'),
                ),
              ),
              Link(
                uri: Uri.parse('/sign-up'),
                builder:
                    (context, followLink) => TextButton(
                  onPressed: followLink,
                  child: const Text('Don\'t have an account? Sign up',style: TextStyle(color: Constants.paleGreen, decoration: TextDecoration.underline),),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}