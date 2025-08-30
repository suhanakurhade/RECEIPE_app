import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  void editMealPlan(BuildContext context, String docId, Map<String, dynamic> plan) {
    final days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    String selectedDay = plan["day"];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Edit Meal Plan"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                value: selectedDay,
                items: days.map((day) {
                  return DropdownMenuItem(value: day, child: Text(day));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedDay = val!;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("mealPlans")
                    .doc(docId)
                    .update({"day": selectedDay});

                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${plan["recipeTitle"]} moved to $selectedDay")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meal Plan")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("mealPlans")
            .orderBy("day")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No meals planned yet."));
          }

          final plans = snapshot.data!.docs;

          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final doc = plans[index];
              final plan = doc.data() as Map<String, dynamic>;
              final docId = doc.id;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(plan["imageUrl"], width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(plan["recipeTitle"]),
                  subtitle: Text("Day: ${plan["day"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => editMealPlan(context, docId, plan),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance.collection("mealPlans").doc(docId).delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${plan["recipeTitle"]} removed")),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
