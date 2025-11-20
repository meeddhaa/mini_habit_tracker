import 'package:flutter/material.dart';

class AddHabitPage extends StatelessWidget {
  const AddHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a New Habit')),
      body: Center(child: Text('Here you can add your habit!')),
    );
  }
}
