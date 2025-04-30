//recipe.dart
//Chidi Emenike
//4/30/25
//My Recipe class model


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
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'ingredients': ingredients, // Make sure it's a List<String>
      'instructions': instructions,
    };
  }

  // Create a Recipe object from a Map
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] as String,
      category: json['category'] as String,
      // Ensure we are converting ingredients to List<String>
      ingredients: List<String>.from(json['ingredients'] as List),
      instructions: json['instructions'] as String,
    );
  }
}
