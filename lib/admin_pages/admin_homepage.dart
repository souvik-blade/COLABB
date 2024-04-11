import 'package:colabb/admin_pages/admin_assignmentpage.dart';
import 'package:colabb/admin_pages/admin_schedulepage.dart';
import 'package:colabb/admin_pages/admin_statspage.dart';
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
                icon: const Icon(Icons.logout),
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

        // body: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         'Welcome to the Admin Dashboard',
        //         style: TextStyle(fontSize: 20.0),
        //       ),
        //       SizedBox(height: 20.0),
        //       ElevatedButton(
        //         onPressed: () {
        //           // Implement functionality to fetch and display data from Firestore
        //         },
        //         child: Text('Fetch Data'),
        //       ),
        //       // Placeholder for displaying data from Firestore
        //       // Replace this with your actual data display widgets
        //       Container(
        //         margin: EdgeInsets.symmetric(vertical: 20.0),
        //         padding: EdgeInsets.all(10.0),
        //         decoration: BoxDecoration(
        //           border: Border.all(color: Colors.grey),
        //           borderRadius: BorderRadius.circular(10.0),
        //         ),
        //         child: Text(
        //           'Data from Firestore will be displayed here',
        //           style: TextStyle(fontSize: 16.0),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
