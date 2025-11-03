import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:mini_habit_tracker/pages/models/app_settings.dart';
import 'package:mini_habit_tracker/pages/models/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // Initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  // Save first launch date (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get first launch date (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  // List of habits in memory
  final List<Habit> currentHabits = [];

  // CREATE - Add new habit
  Future<void> addHabit(String habitName) async {
    final newHabit = Habit(name: '')..name = habitName..completedDays = [];

    await isar.writeTxn(() async {
      await isar.habits.put(newHabit);
    });

    await readHabits();
    notifyListeners();
  }

  // READ - Load all habits
  Future<void> readHabits() async {
    final fetchedHabits = await isar.habits.where().findAll();
    currentHabits
      ..clear()
      ..addAll(fetchedHabits);
    notifyListeners();
  }

  // UPDATE - Toggle habit completion
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit == null) return;

    await isar.writeTxn(() async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final todayMs = today.millisecondsSinceEpoch;

      if (isCompleted) {
        if (!habit.completedDays.contains(todayMs)) {
          habit.completedDays.add(todayMs);
        }
      } else {
        habit.completedDays.removeWhere((ms) {
          final date = DateTime.fromMillisecondsSinceEpoch(ms);
          return date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
        });
      }

      await isar.habits.put(habit);
    });

    await readHabits();
  }

  // UPDATE - Edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit == null) return;

    await isar.writeTxn(() async {
      habit.name = newName;
      await isar.habits.put(habit);
    });

    await readHabits();
  }

  // DELETE - Remove habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    await readHabits();
  }
}
