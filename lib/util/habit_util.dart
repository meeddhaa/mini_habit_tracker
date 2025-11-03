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
Map<DateTime, int> prepHeatmapDataset(List<Habit> habits, {int maxIntensity = 5}) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var ms in habit.completedDays) {
      final date = DateTime.fromMillisecondsSinceEpoch(ms);
      // Normalize to local date (midnight)
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // Increment count and clamp to maxIntensity
      dataset[normalizedDate] = ((dataset[normalizedDate] ?? 0) + 1).clamp(1, maxIntensity);
    }
  }

  return dataset;
}
