import 'package:colabb/components/assignment_tile.dart';
import 'package:colabb/components/my_bottomappbar.dart';
import 'package:flutter/material.dart';

class AssignmentPage extends StatelessWidget {
  static const String id = "assignmentid";
  const AssignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignments"),
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: MyBottomAppBar(),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext, index) {
            return AssignmentTile(
              aboutAssignment: "MAke ",
              assignedDate: "12.12.12",
              dueDate: "12''12'",
            );
          }),
    );
  }
}
