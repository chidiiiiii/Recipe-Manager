//edit_recipes.dart
//Chidi Emenike
//4/30/25
//Edit Recipes Screen


import 'package:flutter/material.dart';
import '../data/recipe_data.dart';
import '../models/recipe.dart';

class EditRecipeForm extends StatefulWidget {
  final Recipe recipe;
  final int index;

  const EditRecipeForm({super.key, required this.recipe, required this.index});

  @override
  _EditRecipeFormState createState() => _EditRecipeFormState();
}

class _EditRecipeFormState extends State<EditRecipeForm> {
  late TextEditingController _nameController;
  late TextEditingController _ingredientNameController;
  late TextEditingController _ingredientQuantityController;
  late TextEditingController _instructionsController;

  List<Map<String, String>> _ingredients = [];
  String _selectedCategory = 'Breakfast';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.recipe.name);
    _instructionsController = TextEditingController(text: widget.recipe.instructions);

    // Parse ingredients into name-quantity pairs
    _ingredients = widget.recipe.ingredients.map((ingredient) {
      final match = RegExp(r'^(.*?)\s*\((.*?)\)$').firstMatch(ingredient);
      if (match != null) {
        return {'name': match.group(1)!, 'quantity': match.group(2)!};
      } else {
        return {'name': ingredient, 'quantity': ''};
      }
    }).toList();

    _selectedCategory = widget.recipe.category;
    _ingredientNameController = TextEditingController();
    _ingredientQuantityController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ingredientNameController.dispose();
    _ingredientQuantityController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final name = _ingredientNameController.text.trim();
    final quantity = _ingredientQuantityController.text.trim();

    if (name.isNotEmpty && quantity.isNotEmpty) {
      setState(() {
        _ingredients.add({'name': name, 'quantity': quantity});
        _ingredientNameController.clear();
        _ingredientQuantityController.clear();
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty ||
        _ingredients.isEmpty ||
        _instructionsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields before saving."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedIngredients = _ingredients.map((ingredient) {
      return '${ingredient['name']} (${ingredient['quantity']})';
    }).toList();

    final updatedRecipe = Recipe(
      name: _nameController.text,
      category: _selectedCategory,
      ingredients: updatedIngredients,
      instructions: _instructionsController.text,
    );

    setState(() {
      recipeList[widget.index] = updatedRecipe;
    });

    await saveRecipesToFile();
    if (mounted) Navigator.pop(context, updatedRecipe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Recipe")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Recipe Name"),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Breakfast', 'Lunch', 'Dinner']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
                decoration: InputDecoration(labelText: "Category"),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingredientNameController,
                      decoration: InputDecoration(labelText: "Ingredient Name"),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _ingredientQuantityController,
                      decoration: InputDecoration(labelText: "Quantity"),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addIngredient,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: _ingredients.map((ingredient) {
                  return Chip(
                    label: Text('${ingredient['name']} (${ingredient['quantity']})'),
                    deleteIcon: Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        _ingredients.remove(ingredient);
                      });
                    },
                  );
                }).toList(),
              ),
              TextField(
                controller: _instructionsController,
                decoration: InputDecoration(labelText: "Instructions"),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
