import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../recipe.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe? recipe;
  EditRecipeScreen({super.key, this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _ratingController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _timeController = TextEditingController();
  final List<String> _ingredients = [];

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _titleController.text = widget.recipe!.title;
      _authorController.text = widget.recipe!.author;
      _categoryController.text = widget.recipe!.category;
      _imageUrlController.text = widget.recipe!.imageUrl;
      _instructionsController.text = widget.recipe!.instructions;
      _ratingController.text = widget.recipe!.rating.toString();
      _caloriesController.text = widget.recipe!.calories.toString();
      _timeController.text = widget.recipe!.time;
      _ingredients.addAll(widget.recipe!.ingredients);
    }
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      final recipe = Recipe(
        id: widget.recipe?.id ?? "",
        title: _titleController.text,
        author: _authorController.text,
        category: _categoryController.text,
        imageUrl: _imageUrlController.text,
        ingredients: _ingredients,
        instructions: _instructionsController.text,
        rating: double.tryParse(_ratingController.text) ?? 0,
        calories: int.tryParse(_caloriesController.text) ?? 0,
        time: _timeController.text,
      );

      FirebaseFirestore.instance.collection("recipes").doc(recipe.id.isEmpty ? null : recipe.id).set({
        "title": recipe.title,
        "author": recipe.author,
        "category": recipe.category,
        "imageUrl": recipe.imageUrl,
        "ingredients": recipe.ingredients,
        "instructions": recipe.instructions,
        "rating": recipe.rating,
        "calories": recipe.calories,
        "time": recipe.time,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add / Edit Recipe")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: "Title")),
              TextFormField(controller: _authorController, decoration: const InputDecoration(labelText: "Author")),
              TextFormField(controller: _categoryController, decoration: const InputDecoration(labelText: "Category")),
              TextFormField(controller: _imageUrlController, decoration: const InputDecoration(labelText: "Image URL")),
              TextFormField(controller: _instructionsController, decoration: const InputDecoration(labelText: "Instructions")),
              TextFormField(controller: _ratingController, decoration: const InputDecoration(labelText: "Rating")),
              TextFormField(controller: _caloriesController, decoration: const InputDecoration(labelText: "Calories")),
              TextFormField(controller: _timeController, decoration: const InputDecoration(labelText: "Time")),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveRecipe, child: const Text("Save Recipe")),
            ],
          ),
        ),
      ),
    );
  }
}
