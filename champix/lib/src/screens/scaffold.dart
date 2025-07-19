import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChampignonstoreScaffold extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const ChampignonstoreScaffold({
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
          if (idx == 0) goRouter.go('/champignon');
          if (idx == 1) goRouter.go('/detect');
          if (idx == 2) goRouter.go('/profile');
        },
        destinations:  const [
          AdaptiveScaffoldDestination(title: 'Mushromms', icon: Icons.person),
          AdaptiveScaffoldDestination(title: 'Scan', icon: Icons.add_a_photo),
          AdaptiveScaffoldDestination(title: 'Profile', icon: Icons.person),
        ],
      ),
    );
  }
}