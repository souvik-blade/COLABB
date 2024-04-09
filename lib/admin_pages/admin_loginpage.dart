import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colabb/admin_pages/admin_homepage.dart';
import 'package:colabb/admin_pages/admin_schedulepage.dart';
import 'package:colabb/components/my_button.dart';
import 'package:colabb/components/my_textfield.dart';
import 'package:colabb/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminLoginScreen extends StatelessWidget {
  static const String id = "adminloginscreenid";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInAsAdmin(BuildContext context) async {
    // auth service
    final authService = AuthService();

    // try login
    try {
      await authService.adminSignInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );

      // Check if the signed-in user is an admin (you need to implement this logic)
      // For example, you can store user roles in Firestore and check if the user is an admin here

      // If user is an admin, navigate to admin dashboard
      //{
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AdminScheduleUploadScreen()));
      // } else {
      //   showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text("Invalid admin ID"),
      //     ),
      //   );
      // }
    } catch (e) {
      // Handle login errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
              controller: _emailController,
              hintText: 'Admin email',
              obscureText: false,
            ),
            SizedBox(height: 10.0),
            MyTextField(
              controller: _passwordController,
              obscureText: true,
              hintText: 'password',
            ),
            SizedBox(height: 25.0),
            MyButton(
              onTap: () => _signInAsAdmin(context),
              text: 'Login as Admin',
            ),
          ],
        ),
      ),
    );
  }
}
