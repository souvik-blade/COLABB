import 'package:flutter/material.dart';

class ScheduleTile extends StatelessWidget {
  final String from;
  final String to;
  final String subject;
  const ScheduleTile(
      {required this.subject, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(from,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400)),
              const Text(" - "),
              Text(to,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400)),
              const SizedBox(width: 20),
            ],
          ),
          Text(
            subject,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }
}
