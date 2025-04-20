import 'package:flutter/material.dart';
import '../data/recipe_data.dart';
import '../models/recipe.dart';

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
              ? Center(child: Text("No recipes added."))
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...recipes.map(
                            (recipe) => ListTile(
                              title: Text(recipe.name),
                              onTap:
                                  () => showDialog(
                                    context: context,
                                    builder:
                                        (_) => AlertDialog(
                                          title: Text(recipe.name),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Category: ${recipe.category}",
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Ingredients:\n${recipe.ingredients.join(', ')}",
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Instructions:\n${recipe.instructions}",
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: Text("Close"),
                                            ),
                                          ],
                                        ),
                                  ),
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    }).toList(),
              ),
    );
  }
}
