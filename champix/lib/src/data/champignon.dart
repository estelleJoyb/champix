class Champignon {
  final int id;
  final String name;
  final String description;
  final bool edible;
  final String? country;
  final String? imageurl;

  Champignon({
    required this.id,
    required this.name,
    required this.description,
    required this.edible,
    this.country,
    this.imageurl,
  });

  factory Champignon.fromJson(Map<String, dynamic> json) {
    return Champignon(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      edible: json['edible'],
      country: json['country'],
      imageurl: json['imageurl'],
    );
  }
}
