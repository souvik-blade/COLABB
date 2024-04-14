import 'package:colabb/admin_pages/admin_assignmentpage.dart';
import 'package:colabb/admin_pages/admin_schedulepage.dart';
import 'package:colabb/admin_pages/admin_settings.dart';
import 'package:colabb/admin_pages/admin_statspage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/tab_item.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // // Function to handle logout
  // void _logout() async {
  //   await _auth.signOut();
  //   // Navigate back to login screen or any other screen as needed
  //   Navigator.pop(context);
  // }

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
                icon: const Icon(
                  CupertinoIcons.gear,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminSettingsPage(),
                    ),
                  );
                },
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
                      TabItem(title: 'Assignment'),
                      TabItem(title: 'Schedule'),
                      TabItem(title: 'App Stats'),
                    ],
                  ),
                ),
              ),
            )),
        body: TabBarView(
          children: [
            AdminAssignmentPage(),
            AdminScheduleUploadScreen(),
            AdminStatsPage()
          ],
        ),
      ),
    );
  }
}
