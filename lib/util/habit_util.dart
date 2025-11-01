// given a habit lsit of completion days
//is the habit completed today?
bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.day == today.day &&
        date.month == today.month &&
        date.year == today.year,
  );
}
