import '../services/auth/auth_service.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final void Function()? onTap;
  RegisterPage({required this.onTap});

  void register(BuildContext context) {
    //get auth service

    final _auth = AuthService();

    //try sign up ifpasswords match
    if (_pwController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      }

      //catch any errrors
      catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }

    // if passwords don't match then fix
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("passwords don't match!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 50),
            Center(
              child: Text(
                "Let's create an account for you",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 25),
            MyTextField(
              hintText: "e-mail",
              obscureText: false,
              controller: _emailController,
            ),
            SizedBox(height: 10),
            MyTextField(
              hintText: "password",
              obscureText: true,
              controller: _pwController,
            ),
            SizedBox(height: 10),
            MyTextField(
              hintText: "confirm password",
              obscureText: true,
              controller: _confirmPwController,
            ),
            SizedBox(
              height: 25,
            ),
            MyButton(
              onTap: () => register(context),
              text: "Register",
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
