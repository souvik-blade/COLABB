import 'package:cloud_firestore/cloud_firestore.dart';
import '../../admin_pages/admin_homepage.dart';
import 'login_or_register.dart';
import '../../pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // user is logged in
            return FutureBuilder(
              future: isAdmin(snapshot.data as User),
              builder: (context, isAdminSnapshot) {
                if (isAdminSnapshot.hasData) {
                  // If user is admin, navigate to admin home page
                  if (isAdminSnapshot.data!) {
                    return AdminDashboardScreen();
                  } else {
                    // If user is not admin, navigate to regular home page
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

  Future<bool> isAdmin(User user) async {
    // Query 'admins' collection to check if user is an admin
    QuerySnapshot adminSnapshot = await _firestore
        .collection('admins')
        .where('uid', isEqualTo: user.uid)
        .get();

    if (adminSnapshot.docs.isNotEmpty) {
      // User is an admin
      return true;
    } else {
      // User is not an admin

      // Implement logic to check if user is an admin
      // For example, query Firestore to check if user is in admin collection
      // Return true if user is admin, false otherwise
      return false;
    }
  }
}
