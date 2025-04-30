import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // for groupBy
import '../data/recipe_data.dart';
import '../models/recipe.dart';
import 'edit_recipes.dart';

class ViewRecipesScreen extends StatefulWidget {
  const ViewRecipesScreen({super.key});

  @override
  State<ViewRecipesScreen> createState() => _ViewRecipesScreenState();
}

class _ViewRecipesScreenState extends State<ViewRecipesScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = ''; // Holds the current search query

  @override
  Widget build(BuildContext context) {
    // Filter recipes based on the search query (case insensitive)
    final filteredRecipes = recipeList
        .where((recipe) => recipe.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // Group filtered recipes by category using the 'groupBy' function from the collection package
    final groupedRecipes = groupBy(filteredRecipes, (Recipe recipe) => recipe.category);

    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50), // Adjust height for search bar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search recipes...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update search query on text change
                });
              },
            ),
          ),
        ),
      ),
      body: filteredRecipes.isEmpty // If no recipes match search query
          ? Center(
              child: Text(
                "No matching recipes found.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: groupedRecipes.keys.length,
              itemBuilder: (context, index) {
                final category = groupedRecipes.keys.elementAt(index);
                final recipes = groupedRecipes[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display category header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    // Display list of recipes for each category
                    ...recipes.map((recipe) {
                      final recipeIndex = recipeList.indexOf(recipe); // Find the index of the recipe
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            tileColor: Colors.white,
                            title: Text(recipe.name),
                            subtitle: Text(
                              recipe.ingredients.join(', ').length > 40
                                  ? '${recipe.ingredients.join(', ').substring(0, 40)}...'
                                  : recipe.ingredients.join(', '),
                            ),
                            trailing: Icon(Icons.edit), // Edit icon
                            onTap: () {
                              // Open the edit recipe dialog on tap
                              _showRecipeDialog(context, recipe, recipeIndex);
                            },
                          ),
                          Divider(), // Divider between recipes
                        ],
                      );
                    }),
                  ],
                );
              },
            ),
    );
  }

  // Show the recipe details in a dialog
  void _showRecipeDialog(BuildContext context, Recipe recipe, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(recipe.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display category
              Text("Category: ${recipe.category}", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              // Display ingredients
              Text("Ingredients:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(recipe.ingredients.join(', ')),
              SizedBox(height: 10),
              // Display instructions
              Text("Instructions:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(recipe.instructions),
            ],
          ),
        ),
        actions: [
          // Edit button - navigate to edit screen
          TextButton(
            child: Text("Edit"),
            onPressed: () async {
              Navigator.pop(context); // Close the dialog first
              final updatedRecipe = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditRecipeForm(recipe: recipe, index: index),
                ),
              );

              if (updatedRecipe != null) {
                // Update the recipe list with the updated recipe
                setState(() {
                  recipeList[index] = updatedRecipe;
                });
              }
            },
          ),
          // Close button
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
