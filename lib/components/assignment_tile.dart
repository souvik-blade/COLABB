import 'package:flutter/material.dart';

class AssignmentTile extends StatelessWidget {
  final String assignedDate;
  final String dueDate;
  final String aboutAssignment;
  const AssignmentTile(
      {super.key,
      required this.assignedDate,
      required this.dueDate,
      required this.aboutAssignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // const Icon(Icons.picture_as_pdf_outlined),

          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Teacher name",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Assignment Instruction")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assigned on:$assignedDate",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Due Date:$assignedDate",
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(Icons.picture_as_pdf_outlined)
        ],
      ),
    );
  }
}
