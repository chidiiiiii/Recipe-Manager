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
  late TextEditingController _ingredientsController;
  late TextEditingController _instructionsController;
  String _selectedCategory = 'Breakfast';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.recipe.name);
    _ingredientsController = TextEditingController(
      text: widget.recipe.ingredients.join(', '),
    );
    _instructionsController = TextEditingController(
      text: widget.recipe.instructions,
    );
    _selectedCategory = widget.recipe.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    // Validate form
    if (_nameController.text.isEmpty ||
        _ingredientsController.text.isEmpty ||
        _instructionsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields before saving."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedRecipe = Recipe(
      name: _nameController.text,
      category: _selectedCategory,
      ingredients:
          _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
      instructions: _instructionsController.text,
    );

    setState(() {
      recipeList[widget.index] = updatedRecipe;
    });

    await saveRecipesToFile(); // Save to JSON file

    // Ensure context is still valid before calling showSnackBar
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Recipe updated successfully.")));
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
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Recipe Name"),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items:
                    ['Breakfast', 'Lunch', 'Dinner']
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged:
                    (value) => setState(() => _selectedCategory = value!),
                decoration: InputDecoration(labelText: "Category"),
              ),
              TextField(
                controller: _ingredientsController,
                decoration: InputDecoration(
                  labelText: "Ingredients (comma-separated)",
                ),
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
