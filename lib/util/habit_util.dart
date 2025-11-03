import 'package:mini_habit_tracker/pages/models/habit.dart';

// Check if the habit is completed today
bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.day == today.day &&
        date.month == today.month &&
        date.year == today.year,
  );
}

// Prepare heatmap data from habit list
Map<DateTime, int> prepHeatmapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var ms in habit.completedDays) {
      final date = DateTime.fromMillisecondsSinceEpoch(ms);

      // Normalize date to avoid time mismatches
      final normalizedDate = DateTime(date.year, date.month, date.day);
;

      // Increment the count if date already exists
      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      } else {
        dataset[normalizedDate] = 1;
      }
    }
  }

  return dataset;
}
