import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colabb/services/auth/auth_service.dart';
import '../../admin_pages/admin_homepage.dart';
import 'login_or_register.dart';
import '../../pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // user is logged in
            return FutureBuilder(
              future: _auth.isAdmin(snapshot.data as User),
              builder: (context, isAdminSnapshot) {
                if (isAdminSnapshot.hasData) {
                  // If user is admin, navigate to admin home page
                  if (isAdminSnapshot.data!) {
                    return AdminDashboardScreen();
                  } else {
                    return HomePage();
                  }
                } else {
                  // Show error message if unable to check admin status
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
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
