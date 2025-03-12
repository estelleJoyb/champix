import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:champix/src/data/champignon.dart';
import 'package:go_router/go_router.dart';
import 'package:champix/src/constants/constants.dart';

class ChampignonDetailsScreen extends StatelessWidget {
  final Champignon? champignon;

  const ChampignonDetailsScreen({super.key, this.champignon});

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('data:')) {
      final String base64String = imageUrl.split(',').last;
      final Uint8List bytes = base64Decode(base64String);
      return Image.memory(bytes);
    } else {
      return Image.network(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (champignon == null) {
      return const Scaffold(body: Center(child: Text('Pas de champignons trouvés.')));
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(champignon!.name),
            if(champignon != null)
              Padding(
                padding: const EdgeInsets.only(left : 8.0),
                child: SvgPicture.asset(
                  "assets/images/champignon.svg",
                  colorFilter: ColorFilter.mode(champignon!.isEdible ? Constants.paleGreen : Constants.paleRed, BlendMode.srcIn),
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              champignon!.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if(champignon != null && champignon!.imageurl != null)
              _buildImage(champignon!.imageurl!),
          ],
        ),
      ),
    );
  }
}