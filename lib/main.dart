import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/auth/auth_gate.dart'; // CRITICAL: The Authentication Listener
import 'package:mini_habit_tracker/database/firestore_habit_service.dart';
import 'package:mini_habit_tracker/database/habit_database.dart';
import 'package:mini_habit_tracker/pages/add_habit_page.dart';
import 'package:mini_habit_tracker/pages/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // --- ANONYMOUS SIGN-IN REMOVED ---
  // The app now relies on the AuthGate to check for user login status.

  // Initialize local database (Isar)
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  // Initialize timezone
  tz.initializeTimeZones();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HabitDatabase(),
        ), // Local Isar DB
        Provider(
          create: (context) => FirestoreHabitService(),
        ), // Firestore service
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ), // Theme provider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Habit Tracker',
      theme: themeProvider.themeData,

      // CRITICAL CHANGE: AuthGate is the entry point
      // It decides whether to show the HomePage or LoginOrRegisterPage
      home: const AuthGate(),

      routes: {
        '/addHabit': (context) => const AddHabitPage(),
      },
    );
  }
}
