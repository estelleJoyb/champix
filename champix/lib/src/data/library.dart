
import 'dart:core';
import 'package:champix/src/data/champignon.dart';

final libraryInstance =
Library()
  ..addChampignon(
    name: 'Girolles',
    isEdible: true,
    country: 'France',
    description: 'Les girolles sont des champignons comestibles.',
    imageurl: "https://www.jardiner-malin.fr/wp-content/uploads/2022/04/Girolle.jpg",
  )
  ..addChampignon(
    name: 'Trompettes de la mort',
    isEdible: true,
    country: 'France',
    description: 'Les trompettes de la mort sont des champignons comestibles.',
    imageurl: "https://www.jardiner-malin.fr/wp-content/uploads/2022/05/reconnaitre-trompette-de-la-mort-Craterellus-cornucopioides-640x740.jpg",
  )
  ..addChampignon(
    name: 'Cèpes',
    isEdible: true,
    country: 'France',
    description: 'Les cèpes sont des champignons comestibles.',
    imageurl: "https://www.jardiner-malin.fr/wp-content/uploads/2022/04/cepe-dete-Boletus-aestivalis.jpg",
  )
  ..addChampignon(
    name: 'Amanite tue mouches',
    isEdible: false,
    country: 'France',
    description: 'Les Amanite tue mouches sont des champignons non comestibles.',
  )
  ..addChampignon(
    name: 'Shitake',
    isEdible: true,
    country: 'Japon',
    description: 'Les shitake sont des champignons comestibles.',
  );

class Library {
  final List<Champignon> allChampignon = [];

  void addChampignon({
    required String name,
    required bool isEdible,
    required String country,
    required String description,
    String? imageurl,
  }) {
    var champignon = Champignon(allChampignon.length, name, isEdible, country, description, imageurl);
    allChampignon.add(champignon);
  }

  Champignon getChampignon(String id) {
    final champignonId = int.tryParse(id);

    if (champignonId == null) {
      throw FormatException("Invalid Champignon ID: $id");
    }

    return allChampignon.firstWhere(
          (champignon) => champignon.id == champignonId,
      orElse: () => throw Exception("Champignon not found"),
    );
  }

  List<Champignon> get allChampignons => [...allChampignon];
  List<Champignon> get edibleChampignons => [...allChampignon.where((champignon) => champignon.isEdible)];
  List<Champignon> get nonEdibleChampignons => [...allChampignon.where((champignon) => !champignon.isEdible)];
}