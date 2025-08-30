import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../recipe.dart';
import 'edit_recipe_screen.dart';
import 'recipe_detail_screen.dart'; // ✅ Import added

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChefCraft Recipes")),
      body: Column(
        children: [
          // ✅ Category filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var cat in ["All", "Soup", "Sandwich", "Main Course", "Dessert"])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selectedCategory == cat,
                      onSelected: (_) {
                        setState(() => selectedCategory = cat);
                      },
                    ),
                  ),
              ],
            ),
          ),

          // ✅ Recipe list from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("recipes").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final recipes = snapshot.data!.docs.map((doc) {
                  return Recipe.fromFirestore(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  );
                }).toList();

                final filtered = selectedCategory == "All"
                    ? recipes
                    : recipes.where((r) => r.category == selectedCategory).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("No recipes found"));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final recipe = filtered[index];
                    return ListTile(
                      leading: Image.network(
                        recipe.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image, size: 40),
                      ),
                      title: Text(recipe.title),
                      subtitle: Text("⭐ ${recipe.rating} • ${recipe.calories} cal"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ✅ Floating button outside ListView
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditRecipeScreen(recipe: null), // new recipe
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
