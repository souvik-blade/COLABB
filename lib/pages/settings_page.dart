import 'package:colabb/services/auth/auth_service.dart';
import 'package:colabb/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const String id = "settingsid";
  const SettingsPage({super.key});

  void logout() {
    // get auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: MyBottomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.all(25.0),
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.all(25.0),
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Log Out",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    logout();
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.logout,
                  ),
                  iconSize: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
