import 'package:flutter/material.dart';
import 'screens/main_menu.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Recipe App',
      theme: ThemeData(primarySwatch: Colors.pink), // Or use your custom swatch
      home: MainMenu(),
    );
  }
}
