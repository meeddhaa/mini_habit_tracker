import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/components/my_habit_tile.dart';
import 'package:mini_habit_tracker/components/my_heatmap.dart';
import 'package:mini_habit_tracker/database/habit_database.dart';
import 'package:mini_habit_tracker/pages/models/habit.dart';
import 'package:mini_habit_tracker/pages/notepad_page.dart';
import 'package:mini_habit_tracker/pages/progress_page.dart';
import 'package:mini_habit_tracker/pages/theme/theme_provider.dart';
import 'package:mini_habit_tracker/util/habit_util.dart';
import 'package:mini_habit_tracker/util/notification_helper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  final NotificationHelper notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    // Load habits from local Isar database
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    // Schedule a daily notification for testing (1 min from now)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final now = DateTime.now();
      int testMinute = now.minute + 1;
      int testHour = now.hour;
      if (testMinute >= 60) {
        testMinute = 0;
        testHour = (testHour + 1) % 24;
      }
      await notificationHelper.showDailyReminder(testHour, testMinute, context);
    });
  }

  // Helper method to clear controller after dialog actions
  void _clearController() {
    textController.clear();
  }

  // --- CREATE NEW HABIT DIALOG ---
  // --- CREATE NEW HABIT DIALOG (USING BOTTOM SHEET) ---
  void createNewHabit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // Makes the sheet adjust its size when the keyboard appears
      isScrollControlled: true,
      builder: (context) {
        // Use Padding to ensure content is fully visible above the keyboard
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Keep column height minimal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add New Habit",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: "Create a new Habit",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // CANCEL BUTTON
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _clearController();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  // SAVE BUTTON
                  ElevatedButton(
                    onPressed: () {
                      final newHabitName = textController.text.trim();
                      if (newHabitName.isNotEmpty) {
                        context.read<HabitDatabase>().addHabit(newHabitName);
                      }
                      Navigator.pop(context);
                      _clearController();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Add bottom padding
            ],
          ),
        );
      },
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // --- EDIT HABIT DIALOG ---
  void editHabitBox(Habit habit) {
    // Set controller text before showing dialog
    textController.text = habit.name;

    showDialog(
      context: context,
      builder:
          (context) => SingleChildScrollView(
            // Added scrollable wrapper
            child: AlertDialog(
              title: const Text("Edit Habit"),
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(hintText: "Edit Habit Name"),
              ),
              actions: [
                // SAVE BUTTON
                TextButton(
                  onPressed: () {
                    final updatedName = textController.text.trim();
                    if (updatedName.isNotEmpty) {
                      context.read<HabitDatabase>().updateHabitName(
                        habit.id,
                        updatedName,
                      );
                    }
                    Navigator.pop(context); // Close dialog first
                    _clearController(); // Then clear the controller
                  },
                  child: const Text('Save'),
                ),
                // CANCEL BUTTON
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog first
                    _clearController(); // Then clear the controller
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
    );
  }

  // --- DELETE HABIT DIALOG ---
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Habit'),
            content: const Text('Are you sure you want to remove this habit?'),
            actions: [
              // Secondary Action Button (Set Reminder)
              TextButton(
                onPressed: () {
                  // Optional: Set daily reminder at a fixed time (8:30 PM)
                  notificationHelper.showDailyReminder(20, 30, context);
                  // Added pop to close this dialog after setting the reminder
                  Navigator.pop(context);
                },
                child: const Text("Set Daily Reminder"),
              ),
              // CANCEL BUTTON
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              // DELETE BUTTON (Prominent and last)
              ElevatedButton(
                onPressed: () {
                  context.read<HabitDatabase>().deleteHabit(habit.id);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red, // Added red color for delete action
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
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
          // Centered text for when there are no habits
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Text(
                "No habits yet? Add one!",
                style: TextStyle(fontSize: 16),
              ),
            ),
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // Use theme color
              ),
              child: Text(
                'Mini Habit Tracker',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Progress Analytics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProgressPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Notepad'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotepadPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Future settings screen navigation
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
          const SizedBox(height: 25), // Increased spacing
          _buildHabitList(),
        ],
      ),
    );
  }
}
