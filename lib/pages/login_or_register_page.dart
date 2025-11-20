// lib/pages/login_or_register_page.dart

import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/pages/login_page.dart';
import 'package:mini_habit_tracker/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // 1. State Variable: Controls which screen is visible
  bool showLoginPage = true;

  // 2. Toggle Function: Flips the state and rebuilds the widget
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage; // Changes true to false, and vice versa
    });
  }

  @override
  Widget build(BuildContext context) {
    // 3. Conditional Rendering: Shows the correct page based on the state
    if (showLoginPage) {
      // Passes the togglePages function down to the LoginPage
      return LoginPage(onTap: togglePages);
    } else {
      // Passes the togglePages function down to the RegisterPage
      return RegisterPage(onTap: togglePages);
    }
  }
}
