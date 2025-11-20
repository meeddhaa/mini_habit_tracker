import 'package:isar/isar.dart';

part 'habit.g.dart';

@Collection()
class Habit {
  Id id = Isar.autoIncrement;

  late String name;

  // Store completed days as timestamps
  late List<int> completedDays = [];

  // Constructor
  Habit({required this.name, List<int>? completedDaysParam}) {
    if (completedDaysParam != null) {
      completedDays = completedDaysParam;
    }
  }

  // Helper to add a completed day
  void addCompletedDay(DateTime day) {
    completedDays.add(day.millisecondsSinceEpoch);
  }

  // Helper to get DateTime objects
  List<DateTime> getCompletedDays() {
    return completedDays
        .map((ms) => DateTime.fromMillisecondsSinceEpoch(ms))
        .toList();
  }
}
