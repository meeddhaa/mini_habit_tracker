import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/components/my_habit_tile.dart';
import 'package:mini_habit_tracker/components/my_heatmap.dart';
import 'package:mini_habit_tracker/database/habit_database.dart';
import 'package:mini_habit_tracker/pages/models/habit.dart';
import 'package:mini_habit_tracker/pages/progress_page.dart';
import 'package:mini_habit_tracker/pages/theme/theme_provider.dart';
import 'package:mini_habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';
import 'package:mini_habit_tracker/util/notification_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
  }

  void createNewHabit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Create a new Habit"),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              final newHabitName = textController.text.trim();
              if (newHabitName.isNotEmpty) {
                context.read<HabitDatabase>().addHabit(newHabitName);
              }
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
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

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Edit Habit Name"),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              final updatedName = textController.text.trim();
              if (updatedName.isNotEmpty) {
                context.read<HabitDatabase>().updateHabitName(
                      habit.id,
                      updatedName,
                    );
              }
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
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

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: const Text('Are you sure you want to remove this habit?'),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              NotificationHelper().showDailyReminder(20, 30); // reminder at 8:30 PM
            },
            child: const Text("Set Daily Reminder"),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList() {
    return Consumer<HabitDatabase>(
      builder: (context, db, _) {
        final habits = db.currentHabits;
        if (habits.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: Text("No habits yet? Add one!")),
          );
        }

        return ListView.builder(
          itemCount: habits.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final habit = habits[index];
            final completedDates =
                habit.completedDays
                    .map((ms) => DateTime.fromMillisecondsSinceEpoch(ms))
                    .toList();
            final isCompletedToday = isHabitCompletedToday(completedDates);

            return MyHabitTile(
              text: habit.name,
              isHabitCompletedToday: isCompletedToday,
              onChanged: (value) => checkHabitOnOff(value, habit),
              editHabit: (context) => editHabitBox(habit),
              deleteHabit: (context) => deleteHabitBox(habit),
              completedDays: completedDates,
            );
          },
        );
      },
    );
  }

  Widget _buildHeatMap() {
    return Consumer<HabitDatabase>(
      builder: (context, db, _) {
        if (db.currentHabits.isEmpty) return const SizedBox.shrink();

        return FutureBuilder<DateTime?>(
          future: db.getFirstLaunchDate(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            final startDate = snapshot.data!;
            final heatmapData = prepHeatmapDataset(db.currentHabits);

            // Debug: print dataset
            heatmapData.forEach((key, value) {
              print("Heatmap key: $key value: $value");
            });

            return MyHeatMap(startDate: startDate, datasets: heatmapData);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Mini Habit Tracker'),
        actions: [
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
            activeColor: Theme.of(context).colorScheme.inversePrimary,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Mini Habit Tracker',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Progress Analytics'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProgressPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewHabit(context),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeatMap(),
          const SizedBox(height: 10),
          _buildHabitList(),
        ],
      ),
    );
  }
}
