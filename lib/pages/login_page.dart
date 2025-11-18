// lib/pages/login_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap; // Used to switch to Register
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
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // 4. Handle Errors
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication Error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: emailController, decoration: const InputDecoration(hintText: "Email")),
              const SizedBox(height: 10),
              TextField(controller: passwordController, decoration: const InputDecoration(hintText: "Password"), obscureText: true),
              const SizedBox(height: 25),
              // Sign In Button
              ElevatedButton(onPressed: () => signIn(context), child: const Text("Sign In")),
              const SizedBox(height: 50),
              // Toggle to Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member?"),
                  GestureDetector(
                    onTap: onTap, 
                    child: const Text(" Register Now", style: TextStyle(fontWeight: FontWeight.bold)),
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