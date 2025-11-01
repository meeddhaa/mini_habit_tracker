import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/database/habit_database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// text controller
final TextEditingController textEditingController = TextEditingController();

// create new habit
void createNewHabit(BuildContext context) {
  final TextEditingController TextController = TextEditingController();

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          content: TextField(
            controller: TextController,
            decoration: const InputDecoration(hintText: "Create a new Habit"),
          ),
          actions: [
            // save button
            MaterialButton(
              onPressed: () {
                // get the new habit name
                String newHabitName = TextController.text;

                // save to db
                context.read<HabitDatabase>().addHabit(newHabitName);

                // pop box
                Navigator.pop(context);

                // clear controller
                TextController.clear();
              },
              child: const Text('Save'),
            ),

            // cancel button
            MaterialButton(
              onPressed: () {
                // pop box
                Navigator.pop(context);

                // clear controller
                TextController.clear();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
  );
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(),
      drawer: const HomePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewHabit(context),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
