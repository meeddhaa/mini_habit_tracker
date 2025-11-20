// lib/auth/auth_gate.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/pages/home_page.dart';
import 'package:mini_habit_tracker/pages/login_or_register_page.dart'; // We create this next

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // This stream listens to changes in the user's sign-in state
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. LOADING: Show loading indicator while checking status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. USER LOGGED IN: snapshot.hasData means a user is active
          if (snapshot.hasData) {
            return const HomePage(); // Show the main app
          } 
          
          // 3. NO USER: Show the login/register screen
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}