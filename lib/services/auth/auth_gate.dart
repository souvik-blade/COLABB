import 'package:colabb/services/auth/login_or_register.dart';
import 'package:colabb/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // user is logged in
            return HomePage();
          }

          // user is not logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
