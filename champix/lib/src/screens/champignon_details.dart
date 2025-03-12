import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:champix/src/data/champignon.dart';
import 'package:go_router/go_router.dart';

class ChampignonDetailsScreen extends StatelessWidget {
  final Champignon? champignon;

  const ChampignonDetailsScreen({super.key, this.champignon});

  @override
  Widget build(BuildContext context) {
    if (champignon == null) {
      return const Scaffold(body: Center(child: Text('Pas de champignons trouvés.')));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(champignon!.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              champignon!.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              champignon!.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SvgPicture.asset(
              "assets/images/champignon.svg",
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}