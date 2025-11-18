import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mini_habit_tracker/util/habit_util.dart';

class MyHabitTile extends StatefulWidget {
  final String text;
  final bool isHabitCompletedToday;
  final List<DateTime> completedDays;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isHabitCompletedToday,
    required this.completedDays,
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

  // Use didUpdateWidget to ensure the state updates if the parent widget changes the completion status
  @override
  void didUpdateWidget(covariant MyHabitTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHabitCompletedToday != oldWidget.isHabitCompletedToday) {
      isCompleted = widget.isHabitCompletedToday;
    }
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      // Increased vertical padding for better spacing between tiles
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Slidable(
        // Applied the soft corner radius to the slidable actions
        key: ValueKey(widget.text),
        groupTag: 'habit_actions', 
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // Edit option
            SlidableAction(
              onPressed: widget.editHabit,
              backgroundColor: colorScheme.secondary, // Use secondary color
              foregroundColor: colorScheme.inversePrimary,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(16), // Larger radius for consistency
            ),
            // Delete option
            SlidableAction(
              onPressed: widget.deleteHabit,
              backgroundColor: colorScheme.error, // Use theme error color (red)
              foregroundColor: Colors.white,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(16), // Larger radius for consistency
            ),
          ],
        ),
        
        // --- Aesthetic Tile Container ---
        child: GestureDetector(
          onTap: toggleCompletion,
          child: Container(
            // Use the Card Theme's shape for the container
            decoration: BoxDecoration(
              // Use Secondary color for uncompleted tile
              color: isCompleted
                  ? colorScheme.tertiary.withOpacity(0.2) // Subtle tint of the accent color when completed
                  : colorScheme.secondary, 
              
              borderRadius: BorderRadius.circular(16), // Use a large, soft radius
              
              // Optional: Subtle shadow for lift in Light Mode
              boxShadow: colorScheme.brightness == Brightness.light && !isCompleted
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Increased padding
            child: ListTile(
              contentPadding: EdgeInsets.zero, // Remove ListTile's default padding

              leading: Checkbox(
                // Use the theme's tertiary (violet accent) color
                activeColor: colorScheme.tertiary,
                checkColor: colorScheme.surface, // Checkmark color should contrast with the active color
                value: isCompleted,
                onChanged: (_) => toggleCompletion(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600, // Slightly less bold for modern look
                      // Text color: Primary text color, but slightly dimmed if completed
                      color: isCompleted
                          ? colorScheme.inversePrimary.withOpacity(0.6) 
                          : colorScheme.inversePrimary,
                      decoration: isCompleted ? TextDecoration.lineThrough : null, // Strikethrough for completed
                      decorationThickness: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Display streak
                  Text(
                    '🔥 ${calculateStreak(widget.completedDays)} day streak',
                    style: TextStyle(
                        // Use a softer, tertiary-toned color for the streak
                        color: colorScheme.tertiary.withOpacity(0.8), 
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}