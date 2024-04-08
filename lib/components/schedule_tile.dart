import 'package:flutter/material.dart';

class ScheduleTile extends StatelessWidget {
  final String time;
  final String subject;
  ScheduleTile({required this.time, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            time,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            subject,
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
