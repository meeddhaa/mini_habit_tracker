// lib/pages/models/mood_entry.dart
import 'package:isar/isar.dart';

part 'mood_entry.g.dart'; // Isar will generate this file

@collection
class MoodEntry {
  Id id = Isar.autoIncrement; // Auto-incrementing ID

  @Index(unique: true) // Ensure only one mood entry per day
  late DateTime date;

  //  NEW: Stores the emoji string (e.g., '😊', '😐', '😞')
  late String moodEmoji; 

  // Optional: A brief journal note
  String? note;
}