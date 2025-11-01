import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/database/habit_database.dart';
import 'package:mini_habit_tracker/pages/models/habit.dart';
import 'package:mini_habit_tracker/util/habit_util.dart';
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
  final TextEditingController textController = TextEditingController();

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Create a new Habit"),
          ),
          actions: [
            // save button
            MaterialButton(
              onPressed: () {
                // get the new habit name
                String newHabitName = textController.text;

                // save to db
                context.read<HabitDatabase>().addHabit(newHabitName);

                // pop box
                Navigator.pop(context);

                // clear controller
                textController.clear();
              },
              child: const Text('Save'),
            ),

            // cancel button
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
  );
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // read existing habits from database
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text('Mini Habit Tracker')),
      drawer: const HomePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewHabit(context),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
      body: _buildHabitList(),
    );
  }

  // build habit list
  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        final completedDates =
            habit.completedDays
                .map((ms) => DateTime.fromMillisecondsSinceEpoch(ms))
                .toList();
        bool isCompletedToday = isHabitCompletedToday(completedDates);

        return ListTile(
          title: Text(
            habit.name,
            style: TextStyle(
              decoration: isCompletedToday ? TextDecoration.lineThrough : null,
            ),
          ),
        );
      },
    );
  }
}
