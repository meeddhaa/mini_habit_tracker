import 'package:flutter/material.dart';

class MyHabitTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          // toggle the habit completion status
          onChanged!(!isHabitCompletedToday);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              isHabitCompletedToday
                  ? Colors.deepPurpleAccent
                  : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(
            12,
          ), // optional, makes it look nicer
        ),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: ListTile(
          title: Text(text),
          leading: Checkbox(
            activeColor: Colors.indigoAccent,
            value: isHabitCompletedToday,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
