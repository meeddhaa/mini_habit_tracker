import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/database/habit_database.dart';
import 'package:mini_habit_tracker/pages/add_habit_page.dart';
import 'package:mini_habit_tracker/pages/home_page.dart';
import 'package:mini_habit_tracker/pages/theme/theme_provider.dart';
import 'package:mini_habit_tracker/util/notification_helper.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize database
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  // Initialize timezone and notifications
  tz.initializeTimeZones();
  final notificationHelper = NotificationHelper();

  // Schedule a daily reminder at 10:00 AM
  await notificationHelper.showDailyReminder(10, 0);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitDatabase()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Habit Tracker',
      theme: themeProvider.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/addHabit': (context) => const AddHabitPage(),
      },
    );
  }
}
