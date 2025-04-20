import 'package:flutter/material.dart';
import '../data/recipe_data.dart';
import '../models/recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final nameController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionsController = TextEditingController();
  String selectedCategory = "Breakfast";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Recipe")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Recipe Name"),
            ),
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (value) => setState(() => selectedCategory = value!),
              items:
                  ["Breakfast", "Lunch", "Dinner"]
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
            ),
            TextField(
              controller: ingredientsController,
              decoration: InputDecoration(
                labelText: "Ingredients (comma separated)",
              ),
              maxLines: 3,
            ),
            TextField(
              controller: instructionsController,
              decoration: InputDecoration(labelText: "Instructions"),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () async {
                // Create and add the new recipe
                recipeList.add(
                  Recipe(
                    name: nameController.text,
                    category: selectedCategory,
                    ingredients:
                        ingredientsController.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList(),
                    instructions: instructionsController.text,
                  ),
                );

                // Save the updated list to file
                await saveRecipesToFile();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Recipe saved successfully.")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
