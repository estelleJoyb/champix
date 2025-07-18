import 'dart:convert';
import 'dart:typed_data';
import 'package:champix/src/services/mushrooms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../constants/constants.dart';
import '../data/champignon.dart';

class ChampignonDetailsScreen extends StatefulWidget {
  final String champignonId;

  const ChampignonDetailsScreen({required this.champignonId, Key? key})
      : super(key: key);

  @override
  State<ChampignonDetailsScreen> createState() =>
      _ChampignonDetailsScreenState();
}

class _ChampignonDetailsScreenState extends State<ChampignonDetailsScreen> {
  Champignon? champignon;
  bool isLoading = true;
  final MushroomService _mushroomService = MushroomService();

  @override
  void initState() {
    super.initState();
    _fetchChampignon();
  }

  Future<void> _fetchChampignon() async {
    try {
      final data = await _mushroomService.getMushroomById(widget.champignonId);
      setState(() {
        champignon = Champignon.fromJson(data);
        isLoading = false;
      });
    } catch (e) {
      // Gérer erreur
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null) {
      return Image.asset(
        'assets/images/default_mushroom.jpg',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.withOpacity(0.2),
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.white70,
            size: 80,
          ),
        ),
      );
    }
    if (imageUrl.startsWith('data:')) {
      final String base64String = imageUrl.split(',').last;
      final Uint8List bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/default_mushroom.jpg',
          fit: BoxFit.contain,
        ),
      );
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/default_mushroom.jpg',
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (champignon == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Text(
            'Pas de champignons trouvés.',
            style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ) ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Text(
              champignon!.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              "assets/images/champignon.svg",
              colorFilter: ColorFilter.mode(
                champignon!.edible ? Constants.paleGreen : Constants.paleRed,
                BlendMode.srcIn,
              ),
              height: 24,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section
              Container(
                height: 300,
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildImage(champignon!.imageurl),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(0xFF3E2723).withOpacity(0.5), // Brown
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Details card
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF3E2723).withOpacity(0.15), // Brown
                      Colors.black.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and edibility
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            champignon!.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ) ??
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: champignon!.edible
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: champignon!.edible
                                  ? Colors.green.withOpacity(0.4)
                                  : Colors.red.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            champignon!.edible
                                ? 'Comestible'
                                : 'Non Comestible',
                            style: TextStyle(
                              color: champignon!.edible
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Description
                    Text(
                      champignon!.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                            height: 1.4,
                          ) ??
                          const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
