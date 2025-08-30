import 'package:flutter/material.dart';
import '../recipe.dart';
import 'edit_recipe_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditRecipeScreen(recipe: recipe),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  recipe.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Title + Author
              Text(
                recipe.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "By ${recipe.author}",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),

              // ✅ Rating & Calories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("⭐ ${recipe.rating.toString()}",
                      style: const TextStyle(fontSize: 16)),
                  Text("${recipe.calories} cal",
                      style: const TextStyle(fontSize: 16)),
                  Text("⏱ ${recipe.time}", style: const TextStyle(fontSize: 16)),
                ],
              ),
              const Divider(height: 30),

              // ✅ Ingredients
              const Text("Ingredients",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...recipe.ingredients.map((ing) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(ing)),
                  ],
                ),
              )),
              const Divider(height: 30),

              // ✅ Instructions
              const Text("Instructions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(recipe.instructions),
            ],
          ),
        ),
      ),
    );
  }
}
