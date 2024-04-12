import 'admin_assignmentpage.dart';
import 'admin_schedulepage.dart';
import 'admin_statspage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/tab_item.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to handle logout
  void _logout() async {
    await _auth.signOut();
    // Navigate back to login screen or any other screen as needed
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 100,
            title: const Text(
              "Dashboard",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200),
            ),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: Icon(Icons.logout_rounded),
                onPressed: _logout,
              ),
            ],
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromARGB(255, 213, 223, 213),
                  ),
                  child: const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Color.fromARGB(255, 83, 90, 84),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      TabItem(title: 'Assignment', count: 6),
                      TabItem(title: 'Schedule', count: 3),
                      TabItem(title: 'App Stats', count: 1),
                    ],
                  ),
                ),
              ),
            )),
        body: TabBarView(
          children: [
            const AdminAssignmentPage(),
            AdminScheduleUploadScreen(),
            const AdminStatsPage()
          ],
        ),
      ),
    );
  }
}
