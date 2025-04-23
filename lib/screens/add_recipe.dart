import 'package:flutter/material.dart';
import '../data/recipe_data.dart';
import '../models/recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final nameController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionsController = TextEditingController();
  String selectedCategory = "Breakfast";

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

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
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (value) => setState(() => selectedCategory = value!),
                items:
                    ["Breakfast", "Lunch", "Dinner"]
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                decoration: InputDecoration(labelText: "Category"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ingredientsController,
                decoration: InputDecoration(
                  labelText: "Ingredients (comma separated)",
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ingredients';
                  }
                  return null;
                },
              ),
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
              ElevatedButton(
                child: Text("Save"),
                onPressed: () async {
                  // Validate form fields
                  if (_formKey.currentState?.validate() ?? false) {
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

                    // Show success message
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Recipe saved successfully.")),
                    );

                    // Pop the screen after saving
                    // ignore: use_build_context_synchronously
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
