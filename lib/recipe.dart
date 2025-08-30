class Recipe {
  final String id; // Firestore document ID
  final String title;
  final String author;
  final String category;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final double rating;
  final int calories;
  final String time;

  Recipe({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.rating,
    required this.calories,
    required this.time,
  });

  // ✅ Create Recipe from Firestore
  factory Recipe.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Recipe(
      id: documentId,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      instructions: data['instructions'] ?? '',
      rating: _parseDouble(data['rating']),
      calories: _parseInt(data['calories']),
      time: data['time'] ?? '',
    );
  }

  // ✅ helper functions
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
