import 'package:flutter/material.dart';
import '../data/recipe_data.dart';

class DeleteRecipesScreen extends StatefulWidget {
  const DeleteRecipesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeleteRecipesScreenState createState() => _DeleteRecipesScreenState();
}

class _DeleteRecipesScreenState extends State<DeleteRecipesScreen> {
  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Delete Recipe"),
            content: Text(
              "Are you sure you want to delete '${recipeList[index].name}'?",
            ),
            actions: [
              TextButton(
                child: const Text("No"),
                onPressed: () => Navigator.pop(ctx),
              ),
              TextButton(
                child: const Text("Yes"),
                onPressed: () async {
                  setState(() {
                    recipeList.removeAt(index);
                  });

                  // Save the updated list to file
                  await saveRecipesToFile();

                  // ignore: use_build_context_synchronously
                  Navigator.pop(ctx);

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Recipe deleted successfully."),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete Recipes")),
      body:
          recipeList.isEmpty
              ? const Center(child: Text("No recipes to delete."))
              : ListView.builder(
                itemCount: recipeList.length,
                itemBuilder: (context, index) {
                  final recipe = recipeList[index];
                  return ListTile(
                    title: Text(recipe.name),
                    subtitle: Text(recipe.category),
                    trailing: const Icon(Icons.delete, color: Colors.red),
                    onTap: () => _confirmDelete(context, index),
                  );
                },
              ),
    );
  }
}
