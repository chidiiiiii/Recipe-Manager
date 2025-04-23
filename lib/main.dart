import 'package:flutter/material.dart';
import 'screens/main_menu.dart';
import 'data/recipe_data.dart'; // <-- Import this so you can call loadRecipesFromFile()

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async calls before runApp
  await loadRecipesFromFile(); // Load saved recipes from file
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Recipe App',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: MainMenu(),
    );
  }
}
