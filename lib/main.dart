// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/database/firestore_habit_service.dart';
import 'package:mini_habit_tracker/database/habit_database.dart';
import 'package:mini_habit_tracker/pages/add_habit_page.dart';
import 'package:mini_habit_tracker/pages/home_page.dart';
import 'package:mini_habit_tracker/pages/theme/theme_provider.dart';
import 'package:mini_habit_tracker/util/notification_helper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Sign in user anonymously
  try {
    await FirebaseAuth.instance.signInAnonymously();
  } catch (e) {
    print('Firebase Auth failed: $e');
    // Continue without authentication for now
  }

  // Initialize local database (Isar)
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  // Initialize timezone
  tz.initializeTimeZones();
  final notificationHelper = NotificationHelper();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HabitDatabase(),
        ), // local Isar DB
        Provider(
          create: (context) => FirestoreHabitService(),
        ), // Firestore service
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ), // theme provider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // CRUCIAL: Using Consumer guarantees that when the themeProvider's
    // themeData changes (which it does right at startup), the MaterialApp rebuilds.
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aesthetic VIOLET Tracker', // <-- Keep this title for verification!
          
          // The theme data is pulled here, ensuring the latest theme is used.
          theme: themeProvider.themeData,
          
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/addHabit': (context) => const AddHabitPage(),
          },
        );
      },
    );
  }
}