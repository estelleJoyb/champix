import 'package:flutter/material.dart';
import 'package:champix/src/auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
          FilledButton(
            onPressed: () {
              ChampixAuth.of(context).signOut();
            }, child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}