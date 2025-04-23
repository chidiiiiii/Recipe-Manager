import 'package:flutter/material.dart';
import '../data/recipe_data.dart';
import '../models/recipe.dart';
import 'edit_recipes.dart'; // Import this!

class ViewRecipesScreen extends StatelessWidget {
  const ViewRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Group recipes by category
    final Map<String, List<Recipe>> groupedRecipes = {};

    for (var recipe in recipeList) {
      groupedRecipes.putIfAbsent(recipe.category, () => []).add(recipe);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Recipes")),
      body:
          recipeList.isEmpty
              ? Center(
                child: Text(
                  "No recipes added.\nTap the 'Add Recipe' button to get started!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
              : ListView(
                children:
                    groupedRecipes.entries.map((entry) {
                      final category = entry.key;
                      final recipes = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 22, // Slightly larger font size
                                fontWeight: FontWeight.bold,
                                color: Colors.green, // Category color
                              ),
                            ),
                          ),
                          ...recipes.map((recipe) {
                            final index = recipeList.indexOf(recipe);
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  tileColor:
                                      Colors
                                          .white, // Background color for each recipe
                                  title: Text(recipe.name),
                                  trailing: Icon(Icons.edit),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => EditRecipeForm(
                                              recipe: recipe,
                                              index: index,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                Divider(), // Divider between recipes
                              ],
                            );
                          }),
                        ],
                      );
                    }).toList(),
              ),
    );
  }
}
