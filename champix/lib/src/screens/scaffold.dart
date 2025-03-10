import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookstoreScaffold extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const BookstoreScaffold({
    required this.child,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter.of(context);

    return Scaffold(
      body: AdaptiveNavigationScaffold(
        selectedIndex: selectedIndex,
        body: child,
        onDestinationSelected: (idx) {
          if (idx == 0) goRouter.go('/books/popular');
          if (idx == 1) goRouter.go('/authors');
          if (idx == 2) goRouter.go('/settings');
        },
        destinations: const [
          AdaptiveScaffoldDestination(title: 'Champignons', icon: Icons.book),
          AdaptiveScaffoldDestination(title: 'Recettes', icon: Icons.person),
          AdaptiveScaffoldDestination(title: 'Settings', icon: Icons.settings),
        ],
      ),
    );
  }
}