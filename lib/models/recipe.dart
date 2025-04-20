class Recipe {
  String name;
  String category;
  List<String> ingredients;
  String instructions;

  Recipe({
    required this.name,
    required this.category,
    required this.ingredients,
    required this.instructions,
  });

  // Convert a Recipe object into a Map
  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'ingredients': ingredients,
    'instructions': instructions,
  };

  // Create a Recipe object from a Map
  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    name: json['name'],
    category: json['category'],
    ingredients: List<String>.from(json['ingredients']),
    instructions: json['instructions'],
  );
}
