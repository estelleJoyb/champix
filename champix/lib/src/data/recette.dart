import 'champignon.dart';

class Recette {
  final int id;
  final String name;
  final Champignon champignon;
  final List<String> ingredients;
  final String procedure;
  final String description;
  Recette(this.id, this.name, this.champignon, this.ingredients, this.procedure, this.description);
}