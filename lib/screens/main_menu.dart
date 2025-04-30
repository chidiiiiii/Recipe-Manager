import 'package:flutter/material.dart';
import 'add_recipe.dart';
import 'view_recipes.dart';
import 'delete_recipes.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MY RECIPE MANAGER"),
        backgroundColor: const Color.fromARGB(255, 175, 76, 119), // Custom AppBar color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Tooltip(
              message: "Navigate to Add Recipe screen", // Tooltip message
              child: ElevatedButton.icon(
                icon: Icon(Icons.add), // Icon added for 'Add Recipe'
                label: Text("Add Recipe"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddRecipeScreen()),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Tooltip(
              message: "Navigate to View Recipes screen", // Tooltip message
              child: ElevatedButton.icon(
                icon: Icon(Icons.view_list), // Icon for 'View Recipes'
                label: Text("View Recipes"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewRecipesScreen(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Tooltip(
              message: "Navigate to Delete Recipes screen", // Tooltip message
              child: ElevatedButton.icon(
                icon: Icon(Icons.delete), // Icon for 'Delete Recipes'
                label: Text("Delete Recipes"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteRecipesScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
