import 'package:flutter/material.dart';

class CircularAvatar extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  CircularAvatar({required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            CircleAvatar(radius: 40),
            SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
