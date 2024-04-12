// ignore_for_file: use_build_context_synchronously

import 'package:colabb/components/my_button.dart';
import 'package:colabb/components/my_textfield.dart';
import 'package:colabb/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AdminLoginScreen extends StatelessWidget {
  static const String id = "adminloginscreenid";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInAsAdmin(BuildContext context) async {
    // Show circular progress indicator
    // showDialog(
    //   context: context,
    //   barrierDismissible: false, // prevent user from dismissing the dialog
    //   builder: (context) => Center(child: CircularProgressIndicator()),
    // );

    // auth service
    final authService = AuthService();

    // try login
    try {
      await authService.adminSignInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );

      // Hide the progress indicator after login is successful
      Navigator.of(context).pop(); // close the dialog
    } catch (e) {
      // Hide the progress indicator in case of an error
      Navigator.of(context).pop(); // close the dialog

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
