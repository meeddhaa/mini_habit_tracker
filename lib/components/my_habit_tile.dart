import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatefulWidget {
  final String text;
  final bool isHabitCompletedToday;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isHabitCompletedToday,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(), // fixed typo
          children: [
            // edit option
            SlidableAction(
              onPressed: widget.editHabit,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(8),
            ),
            // delete option
            SlidableAction(
              onPressed: widget.deleteHabit,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: toggleCompletion,
          child: Container(
            decoration: BoxDecoration(
              color:
                  isCompleted
                      ? const Color.fromARGB(255, 201, 132, 240)
                      : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: Checkbox(
                activeColor: const Color.fromARGB(255, 159, 105, 195),
                value: isCompleted,
                onChanged: (_) => toggleCompletion(),
              ),
              title: Text(
                widget.text,
                style: TextStyle(
                  color:
                      isCompleted
                          ? Colors.black
                          : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
