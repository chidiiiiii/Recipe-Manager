import 'dart:convert'; // For JSON encoding and decoding
import 'dart:io'; // For file operations
import 'package:path_provider/path_provider.dart'; // To get the local file path
import '../models/recipe.dart'; // Import your Recipe model

// Global list to hold all recipe objects
List<Recipe> recipeList = [];

// Save the current recipe list to a local JSON file
Future<void> saveRecipesToFile() async {
  final file = await _getLocalFile(); // Get the file reference
  final jsonList = recipeList.map((recipe) => recipe.toJson()).toList(); // Convert each recipe to a Map
  await file.writeAsString(json.encode(jsonList)); // Save the JSON string to the file
}

// Load recipes from the local JSON file into recipeList
Future<void> loadRecipesFromFile() async {
  final file = await _getLocalFile(); // Get the file reference
  if (await file.exists()) { // Check if the file actually exists
    final contents = await file.readAsString(); // Read the file contents as a string
    final jsonData = json.decode(contents) as List; // Decode the JSON string into a list of dynamic maps
    recipeList = jsonData.map((item) => Recipe.fromJson(item)).toList(); // Convert maps into Recipe objects
  }
}

// Helper function to get the reference to the local file
Future<File> _getLocalFile() async {
  final directory = await getApplicationDocumentsDirectory(); // Get the app's documents directory
  return File('${directory.path}/recipes.json'); // Return the File object pointing to recipes.json
}
