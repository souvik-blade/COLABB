import 'package:flutter/material.dart';

class UploadButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  UploadButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Expanded(
        child: Container(
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
              color: Colors.teal[100], borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(text)),
        ),
      ),
    );
  }
}
