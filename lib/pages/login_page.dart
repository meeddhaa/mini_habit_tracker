// lib/pages/login_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn(BuildContext context) async {
    // 1. Show loading indicator
    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      // 2. Firebase Sign In
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      
      // 3. Dismiss loading indicator
      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // 4. Handle Errors
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Authentication Error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use colorScheme for easy access to branded colors
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Removed AppBar for a cleaner, full-screen look
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35.0), // Increased padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Aesthetic Logo/Title Placeholder
              Icon(
                Icons.favorite_rounded, // Use an icon for branding
                size: 80,
                color: colorScheme.tertiary, // Use the violet accent color
              ),
              const SizedBox(height: 10),
              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 50),
              
              // 2. Themed Email Input (automatically rounded and filled via ThemeData)
              TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              
              // 3. Themed Password Input
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(hintText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 50),
              
              // 4. Branded Sign In Button
              SizedBox(
                width: double.infinity, // Make button full width
                child: ElevatedButton(
                  onPressed: () => signIn(context),
                  style: ElevatedButton.styleFrom(
                    // Use the violet accent color for the button background
                    backgroundColor: colorScheme.tertiary,
                    foregroundColor: colorScheme.surface, // Text color should be white/surface
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0, // Keep it flat and modern
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // 5. Toggle to Register (Branded Link)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(color: colorScheme.inversePrimary.withOpacity(0.7)),
                  ),
                  GestureDetector(
                    onTap: onTap, 
                    child: Text(
                      " Register Now", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.tertiary, // Use the violet accent for the link
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}