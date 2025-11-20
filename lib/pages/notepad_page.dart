import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// Import intl package for better date formatting if needed, otherwise rely on your existing formatter

class NotepadPage extends StatefulWidget {
  const NotepadPage({super.key});

  @override
  State<NotepadPage> createState() => _NotepadPageState();
}

class _NotepadPageState extends State<NotepadPage> {
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString('notes');
    if (notesJson != null) {
      final List decoded = jsonDecode(notesJson);
      setState(() {
        _notes = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notes', jsonEncode(_notes));
  }

  // Helper function to create the common Note Dialog structure
  Widget _buildNoteDialog({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required String actionText,
    required VoidCallback onActionPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      // Dialog shape inherited from ThemeData.dialogTheme or use shape: 
      title: Text(title),
      content: TextField(
        controller: controller,
        maxLines: null,
        // Inherits rounded input decoration from the theme
        decoration: InputDecoration(
          hintText: 'Write something...',
          // Explicitly set border to none if you want to rely on the theme fill
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: colorScheme.inversePrimary),
          ),
        ),
        ElevatedButton(
          onPressed: onActionPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.tertiary, // Branded violet accent
            foregroundColor: colorScheme.surface, // Text color (white/off-white)
          ),
          child: Text(actionText),
        ),
      ],
    );
  }

  void _addNote() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => _buildNoteDialog(
        context: context,
        title: 'What are you thinking?',
        controller: controller,
        actionText: 'Add',
        onActionPressed: () {
          final text = controller.text.trim();
          if (text.isNotEmpty) {
            setState(() {
              _notes.add({
                'text': text,
                'date': DateTime.now().toIso8601String(),
              });
              // Sort notes after adding a new one to keep the date display accurate
              _notes.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
            });
            _saveNotes();
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  void _editNote(int index) {
    final note = _notes[index];
    final TextEditingController controller =
        TextEditingController(text: note['text']);
    showDialog(
      context: context,
      builder: (context) => _buildNoteDialog(
        context: context,
        title: 'Edit your thought',
        controller: controller,
        actionText: 'Save',
        onActionPressed: () {
          final text = controller.text.trim();
          if (text.isNotEmpty) {
            setState(() {
              _notes[index]['text'] = text;
              _notes[index]['date'] = DateTime.now().toIso8601String();
            });
            _saveNotes();
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteNote(int index) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete note'),
        content: const Text('Dismiss your thoughts?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: colorScheme.inversePrimary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notes.removeAt(index);
              });
              _saveNotes();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error, // Use theme's error color (red)
              foregroundColor: colorScheme.surface,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupNotesByDate() {
    // Sort all notes descending before grouping to ensure the date key sorting is reliable
    _notes.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
    
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var note in _notes) {
      DateTime date = DateTime.parse(note['date']);
      String key = _formatDate(date);

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(note);
    }
    return grouped;
  }

  String _formatDate(DateTime date) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime noteDate = DateTime(date.year, date.month, date.day);
    DateTime todayDate = DateTime(today.year, today.month, today.day);
    DateTime yesterdayDate = DateTime(yesterday.year, yesterday.month, yesterday.day);


    if (noteDate.isAtSameMomentAs(todayDate)) {
      return 'Today';
    } else if (noteDate.isAtSameMomentAs(yesterdayDate)) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotes = _groupNotesByDate();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Diary'),
        elevation: 0, // Aesthetic change: Remove shadow
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.inversePrimary,
      ),
      body: groupedNotes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lightbulb_outline, // A fitting icon
                    size: 60,
                    color: colorScheme.tertiary.withOpacity(0.6),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No thoughts yet! Press + to record your first thought.',
                    style: TextStyle(color: colorScheme.inversePrimary.withOpacity(0.7)),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: groupedNotes.entries.map((entry) {
                final date = entry.key;
                final notes = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Aesthetic Date Header
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: Text(
                        date,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.tertiary), // Use accent color
                      ),
                    ),
                    
                    // List of Notes for this day
                    ...notes.asMap().entries.map((noteEntry) {
                      final index = _notes.indexOf(noteEntry.value);
                      final note = noteEntry.value;
                      final noteTime = DateTime.parse(note['date']);
                      final formattedTime = '${noteTime.hour.toString().padLeft(2, '0')}:${noteTime.minute.toString().padLeft(2, '0')}';

                      return Card(
                        // Card uses the theme's defined Border Radius (16)
                        color: colorScheme.secondary,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(
                            note['text'],
                            style: TextStyle(
                              color: colorScheme.inversePrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            formattedTime, // Display time of the thought
                            style: TextStyle(
                              color: colorScheme.inversePrimary.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit Button
                              IconButton(
                                icon: Icon(Icons.edit, color: colorScheme.tertiary), // Branded icon color
                                onPressed: () => _editNote(index),
                              ),
                              // Delete Button
                              IconButton(
                                icon: Icon(Icons.delete, color: colorScheme.error), // Error color for danger
                                onPressed: () => _deleteNote(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        // Inherits background color from theme's floatingActionButtonTheme or uses tertiary color
        backgroundColor: colorScheme.tertiary, 
        foregroundColor: colorScheme.surface, // Icon color
        child: const Icon(Icons.add),
      ),
    );
  }
}