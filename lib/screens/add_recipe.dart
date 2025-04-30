//add_recipe.dart
//Chidi Emenike
//4/30/25
//Add Recipes Screen



import 'package:flutter/material.dart';
import '../data/recipe_data.dart';
import '../models/recipe.dart';

// Main screen to add a new recipe
class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  // Controllers to handle user input
  final nameController = TextEditingController();
  final instructionsController = TextEditingController();
  final ingredientNameController = TextEditingController();
  final ingredientQuantityController = TextEditingController();

  // Stores the list of ingredients as maps with name and quantity
  final List<Map<String, String>> ingredients = [];

  // Selected recipe category
  String selectedCategory = "Breakfast";

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Adds a new ingredient to the list
  void _addIngredient() {
    final ingredientName = ingredientNameController.text.trim();
    final ingredientQuantity = ingredientQuantityController.text.trim();
    if (ingredientName.isNotEmpty && ingredientQuantity.isNotEmpty) {
      setState(() {
        ingredients.add({
          'name': ingredientName,
          'quantity': ingredientQuantity,
        });
        ingredientNameController.clear();
        ingredientQuantityController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Recipe")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Recipe name input field
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Recipe Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipe name';
                  }
                  return null;
                },
              ),
              // Category dropdown (Breakfast, Lunch, Dinner)
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (value) => setState(() => selectedCategory = value!),
                items: ["Breakfast", "Lunch", "Dinner"]
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                decoration: InputDecoration(labelText: "Category"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold)),
              // Row to input ingredient name and quantity, and add to list
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ingredientNameController,
                      decoration: InputDecoration(hintText: "Ingredient Name"),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: ingredientQuantityController,
                      decoration: InputDecoration(hintText: "Quantity"),
                      onFieldSubmitted: (_) => _addIngredient(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addIngredient,
                  ),
                ],
              ),
              // Display the list of ingredients as chips
              Wrap(
                spacing: 8,
                children: ingredients
                    .map(
                      (ingredient) => Chip(
                        label: Text('${ingredient['name']} (${ingredient['quantity']})'),
                        deleteIcon: Icon(Icons.close),
                        onDeleted: () {
                          setState(() {
                            ingredients.remove(ingredient);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              // Warning if no ingredients are added
              if (ingredients.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Please add at least one ingredient",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              SizedBox(height: 16),
              // Instructions input field
              TextFormField(
                controller: instructionsController,
                decoration: InputDecoration(labelText: "Instructions"),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter instructions';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Save button: validate form, save recipe, show confirmation
              ElevatedButton(
                child: Text("Save"),
                onPressed: () async {
                  if ((_formKey.currentState?.validate() ?? false) &&
                      ingredients.isNotEmpty) {
                    recipeList.add(
                      Recipe(
                        name: nameController.text,
                        category: selectedCategory,
                        ingredients: ingredients.map((ingredient) {
                          return '${ingredient['name']} (${ingredient['quantity']})';
                        }).toList(),
                        instructions: instructionsController.text,
                      ),
                    );
                    await saveRecipesToFile();
                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Recipe saved successfully.")),
                    );
                    // Navigate back to previous screen
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
