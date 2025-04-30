import 'package:flutter/material.dart';
import '../data/recipe_data.dart';
import '../models/recipe.dart';

class EditRecipeForm extends StatefulWidget {
  final Recipe recipe;
  final int index;

  const EditRecipeForm({super.key, required this.recipe, required this.index});

  @override
  
  // ignore: library_private_types_in_public_api
  _EditRecipeFormState createState() => _EditRecipeFormState();
}

class _EditRecipeFormState extends State<EditRecipeForm> {
  late TextEditingController _nameController;
  late TextEditingController _ingredientNameController;
  late TextEditingController _ingredientQuantityController;
  late TextEditingController _instructionsController;

  List<String> _ingredients = [];
  String _selectedCategory = 'Breakfast';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.recipe.name);
    _instructionsController = TextEditingController(text: widget.recipe.instructions);

    // Initialize ingredients with only the name portion
    _ingredients = widget.recipe.ingredients
        .map((ingredient) => ingredient.split(' (')[0])
        .toList();

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

  // Saves the updated recipe
  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty || _ingredients.isEmpty || _instructionsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields before saving."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Combine each ingredient with quantity (if any)
    final updatedIngredients = _ingredients.map((ingredient) {
      final quantity = _ingredientQuantityController.text.trim();
      return quantity.isEmpty ? ingredient : '$ingredient ($quantity)';
    }).toList();

    final updatedRecipe = Recipe(
      name: _nameController.text,
      category: _selectedCategory,
      ingredients: updatedIngredients,
      instructions: _instructionsController.text,
    );

    // Update the recipe in the global list
    setState(() {
      recipeList[widget.index] = updatedRecipe;
    });

    await saveRecipesToFile();

    if (mounted) {
      Navigator.pop(context, updatedRecipe); // Go back and return the updated recipe
    }
  }

  // Adds a new ingredient to the list
  void _addIngredient() {
    final ingredientName = _ingredientNameController.text.trim();
    final ingredientQuantity = _ingredientQuantityController.text.trim();

    if (ingredientName.isNotEmpty) {
      setState(() {
        final formattedIngredient = ingredientQuantity.isNotEmpty
            ? '$ingredientName ($ingredientQuantity)'
            : ingredientName;

        _ingredients.add(formattedIngredient);
        _ingredientNameController.clear();
        _ingredientQuantityController.clear();
      });
    }
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
              // Recipe name input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Recipe Name"),
              ),

              // Category dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Breakfast', 'Lunch', 'Dinner']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
                decoration: InputDecoration(labelText: "Category"),
              ),

              // Ingredient input row
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

              // Display current ingredients
              Wrap(
                spacing: 8,
                children: _ingredients
                    .map(
                      (ingredient) => Chip(
                        label: Text(ingredient),
                        deleteIcon: Icon(Icons.close),
                        onDeleted: () {
                          setState(() {
                            _ingredients.remove(ingredient);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),

              // Instructions input
              TextField(
                controller: _instructionsController,
                decoration: InputDecoration(labelText: "Instructions"),
                maxLines: 4,
              ),

              SizedBox(height: 20),

              // Save button
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

// Empty extension placeholder (can be removed or used later)
extension on Map<String, String> {}
