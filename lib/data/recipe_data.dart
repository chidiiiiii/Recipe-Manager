import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/recipe.dart';

List<Recipe> recipeList = [];

// Save recipes to a local JSON file
Future<void> saveRecipesToFile() async {
  final file = await _getLocalFile();
  final jsonList = recipeList.map((recipe) => recipe.toJson()).toList();
  await file.writeAsString(json.encode(jsonList));
}

// Load recipes from the local JSON file
Future<void> loadRecipesFromFile() async {
  try {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final contents = await file.readAsString();
      final jsonData = json.decode(contents) as List;
      recipeList = jsonData.map((item) => Recipe.fromJson(item)).toList();
    }
  } catch (e) {
    print("Error loading recipes: $e");
  }
}

// Helper function to get the path to the local JSON file
Future<File> _getLocalFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/recipes.json');
}
