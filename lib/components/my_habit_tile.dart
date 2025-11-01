import 'package:flutter/material.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isHabitCompletedToday;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isHabitCompletedToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            isHabitCompletedToday
                ? Colors.deepPurpleAccent
                : Theme.of(context).colorScheme.secondary,
      ),
      child: Text(text),
    );
  }
}
