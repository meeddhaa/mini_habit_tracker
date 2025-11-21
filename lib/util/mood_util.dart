// lib/util/mood_util.dart (New File)

class MoodUtil {
  // 🛑 UPDATED: Aesthetic and expressive icons for mood tracking
  static const List<String> moodOptions = [
    '✨', // Fantastic / Radiant (5)
    '😊', // Good / Happy (4)
    '☁️', // Neutral / Calm (3)
    '🌧️', // Down / Moody (2)
    '🥀', // Terrible / Wilted (1)
  ];
  
  // The mapping remains the same, converting the icon back to a numeric value for charts
  static const Map<String, int> emojiToRating = {
    '✨': 5, // Fantastic
    '😊': 4, // Good
    '☁️': 3, // Neutral
    '🌧️': 2, // Bad
    '🥀': 1, // Terrible
  };
}