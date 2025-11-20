// lib/pages/register_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap; // Used to switch to Login
  RegisterPage({super.key, required this.onTap});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  void signUp(BuildContext context) async {
    // 1. Password Match Check
    if (passwordController.text.trim() != confirmPwController.text.trim()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Passwords do not match!'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return;
    }

    // 2. Show loading indicator
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 3. Firebase Sign Up
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 4. Dismiss loading indicator
      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // 5. Handle Errors
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Registration Error'),
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
          padding: const EdgeInsets.all(35.0), // Consistent padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Aesthetic Logo/Title Placeholder (Consistent with Login Page)
              Icon(
                Icons.favorite_rounded,
                size: 80,
                color: colorScheme.tertiary, // Violet accent
              ),
              const SizedBox(height: 10),
              Text(
                "Create Your Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 50),

              // 2. Themed Email Input
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
              const SizedBox(height: 15),

              // 4. Themed Confirm Password Input
              TextField(
                controller: confirmPwController,
                decoration: const InputDecoration(hintText: "Confirm Password"),
                obscureText: true,
              ),
              const SizedBox(height: 50),

              // 5. Branded Sign Up Button
              SizedBox(
                width: double.infinity, // Full width button
                child: ElevatedButton(
                  onPressed: () => signUp(context),
                  style: ElevatedButton.styleFrom(
                    // Use the violet accent color for the button background
                    backgroundColor: colorScheme.tertiary,
                    foregroundColor: colorScheme.surface,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // 6. Toggle to Login (Branded Link)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style:
                        TextStyle(color: colorScheme.inversePrimary.withOpacity(0.7)),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      " Login Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.tertiary, // Violet accent for link
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
