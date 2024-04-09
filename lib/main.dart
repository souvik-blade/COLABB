import 'package:colabb/admin_pages/admin_loginpage.dart';
import 'package:colabb/pages/assignments_page.dart';
import 'package:colabb/pages/home_page.dart';
import 'package:colabb/pages/mentor_grouppage.dart';
import 'package:colabb/pages/schedule_page.dart';
import 'package:colabb/services/auth/auth_gate.dart';
import 'package:colabb/firebase_options.dart';
import 'package:colabb/pages/settings_page.dart';
import 'package:colabb/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: Colabb(),
  ));
}

class Colabb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        HomePage.id: (context) => HomePage(),
        SettingsPage.id: (context) => SettingsPage(),
        SchedulePage.id: (context) => SchedulePage(),
        AssignmentPage.id: (context) => AssignmentPage(),
        MentorRoom.id: (context) => MentorRoom(),
        AdminLoginScreen.id: (context) => AdminLoginScreen(),
      },
    );
  }
}
