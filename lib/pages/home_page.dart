import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/components/my_habit_tile.dart';
import 'package:mini_habit_tracker/components/my_heatmap.dart';
import 'package:mini_habit_tracker/database/habit_database.dart';
import 'package:mini_habit_tracker/pages/models/habit.dart';
import 'package:mini_habit_tracker/pages/progress_page.dart';
import 'package:mini_habit_tracker/pages/theme/theme_provider.dart';
import 'package:mini_habit_tracker/util/habit_util.dart';
import 'package:mini_habit_tracker/util/habit_util.dart' as HabitUtil;
import 'package:provider/provider.dart';
import 'package:mini_habit_tracker/util/notification_helper.dart';
import 'package:mini_habit_tracker/pages/notepad_page.dart';
import 'package:mini_habit_tracker/util/mood_util.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Existing Controllers
  final TextEditingController textController = TextEditingController();
  final NotificationHelper notificationHelper = NotificationHelper();

  // Mood Tracker State and Controller
  final TextEditingController moodNoteController = TextEditingController();
  String? _selectedMood;

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
  
  
  // MOOD TRACKER DIALOG
  
  
  void showMoodTrackerDialog() {
    _selectedMood = null;
    moodNoteController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: const Text('How are you feeling today?'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- Mood Icon Selector ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: MoodUtil.moodOptions.map((emoji) {
                        return GestureDetector(
                          onTap: () {
                            setStateInDialog(() { 
                              _selectedMood = emoji;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _selectedMood == emoji 
                                  ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _selectedMood == emoji 
                                    ? Theme.of(context).colorScheme.primary 
                                    : Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 35),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 16),

                    // --- Optional Note Input ---
                    TextField(
                      controller: moodNoteController,
                      decoration: InputDecoration(
                        hintText: "Optional: Why do you feel this way?",
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.6)
                        ),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                
                // Save Button
                ElevatedButton(
                  onPressed: _selectedMood == null
                      ? null
                      : () {
                          Provider.of<HabitDatabase>(context, listen: false)
                              .saveMoodEntry(_selectedMood!, moodNoteController.text.trim());
                          
                          Navigator.pop(context);
                        },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  
  // LOG OUT METHOD
  

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    
    if (mounted) {
      // Navigate to the root route, which should trigger the AuthGate or initial login screen
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/', 
        (Route<dynamic> route) => false,
      );
    }
  }

  
  // EXISTING HABIT CRUD METHODS
  

  void createNewHabit(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: "Create a new Habit"),
            ),
            actions: [
              TextButton(
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
              TextButton(
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
      builder:
          (context) => AlertDialog(
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: "Edit Habit Name"),
            ),
            actions: [
              TextButton(
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
              TextButton(
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
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Habit'),
            content: const Text('Are you sure you want to remove this habit?'),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<HabitDatabase>().deleteHabit(habit.id);
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  notificationHelper.showDailyReminder(20, 30, context);
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
            final isCompletedToday = HabitUtil.isHabitCompletedToday(completedDates); 

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
            final heatmapData = HabitUtil.prepHeatmapDataset(db.currentHabits); 

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
          // Mood Tracker Button
          IconButton(
            icon: const Icon(Icons.mood_outlined),
            onPressed: () => showMoodTrackerDialog(),
          ),
          
          //  DELETE YOUR EXISTING LOG OUT ICON BUTTON HERE (if it exists) 
          
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
                
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Mini Habit Tracker',
                style: TextStyle(
                  
                  color: Theme.of(context).colorScheme.inversePrimary,
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
              },
            ),
            // ✅ NEW: LOG OUT BUTTON MOVED TO DRAWER
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: logOut, // Calls the new logOut method
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