import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colabb/components/assignment_tile.dart';
import 'package:flutter/material.dart';
import '../components/my_bottomappbar.dart';

class AssignmentPage extends StatelessWidget {
  static const String id = "assignmentid";
  const AssignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          " Assigments",
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('assignment')
              .orderBy("lastDate", descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                print(index.toString());
                return AssignmentTile(
                  aboutAssignment: document['Instructions'],
                  assignedDate: document['assignedOn'],
                  dueDate: document['lastDate'],
                  facultyName: document['facultyName'],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
