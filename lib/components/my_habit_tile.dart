import 'package:flutter/material.dart';

class MyHabitTile extends StatefulWidget {
  final String text;
  final bool isHabitCompletedToday;
  final void Function(bool?)? onChanged;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isHabitCompletedToday,
    required this.onChanged,
  });

  @override
  State<MyHabitTile> createState() => _MyHabitTileState();
}

class _MyHabitTileState extends State<MyHabitTile> {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.isHabitCompletedToday;
  }

  void toggleCompletion() {
    setState(() {
      isCompleted = !isCompleted;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(isCompleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCompletion,
      child: Container(
        decoration: BoxDecoration(
          color:
              isCompleted
                  ? const Color.fromARGB(255, 149, 117, 237)
                  : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: ListTile(
          title: Text(widget.text),
          leading: Checkbox(
            activeColor: const Color.fromARGB(255, 168, 180, 246),
            value: isCompleted,
            onChanged: (_) => toggleCompletion(),
          ),
        ),
      ),
    );
  }
}
