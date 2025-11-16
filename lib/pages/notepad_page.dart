import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  void _addNote() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('What are you thinking?'),
        content: TextField(
          controller: controller,
          maxLines: null,
          decoration: const InputDecoration(hintText: 'Write something...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _notes.add({
                    'text': text,
                    'date': DateTime.now().toIso8601String(),
                  });
                });
                _saveNotes();
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editNote(int index) {
    final note = _notes[index];
    final TextEditingController controller =
        TextEditingController(text: note['text']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit your thought'),
        content: TextField(
          controller: controller,
          maxLines: null,
          decoration: const InputDecoration(hintText: 'Edit your note...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
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
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete note'),
        content: const Text('Dismiss your thoughts?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notes.removeAt(index);
              });
              _saveNotes();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupNotesByDate() {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var note in _notes) {
      DateTime date = DateTime.parse(note['date']);
      String key = _formatDate(date);

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(note);
    }

    // Sort dates descending
    var sortedKeys = grouped.keys.toList()
      ..sort((a, b) => DateTime.parse(grouped[b]![0]['date'])
          .compareTo(DateTime.parse(grouped[a]![0]['date'])));
    Map<String, List<Map<String, dynamic>>> sortedGrouped = {};
    for (var k in sortedKeys) {
      sortedGrouped[k] = grouped[k]!;
    }

    return sortedGrouped;
  }

  String _formatDate(DateTime date) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotes = _groupNotesByDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Diary'),
      ),
      body: groupedNotes.isEmpty
          ? const Center(
              child: Text('No thoughts yet! Press + to add your thoughts.'),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: groupedNotes.entries.map((entry) {
                final date = entry.key;
                final notes = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...notes.asMap().entries.map((noteEntry) {
                      final index = _notes.indexOf(noteEntry.value);
                      final note = noteEntry.value;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(note['text']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editNote(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteNote(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
