import 'package:flutter/material.dart';
import 'add_recipe.dart';
import 'view_recipes.dart';
import 'edit_recipes.dart';
import 'delete_recipes.dart';
import '../data/recipe_data.dart';
import '../models/recipe.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MY RECIPE MANAGER")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Add Recipe"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRecipeScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("View Recipes"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewRecipesScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Edit Recipes"),
              onPressed: () {
                // Assuming you have a list of recipes stored in recipeList
                if (recipeList.isNotEmpty) {
                  Recipe recipeToEdit =
                      recipeList[0]; // Choose the recipe to edit
                  int recipeIndex = 0; // The index of the recipe in the list

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EditRecipeForm(
                            recipe: recipeToEdit,
                            index: recipeIndex,
                          ),
                    ),
                  );
                } else {
                  // Show a message if the recipe list is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No recipes available to edit")),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Delete Recipes"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeleteRecipesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
