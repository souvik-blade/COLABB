import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddUserTile extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const AddUserTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            // icon
            Icon(Icons.person),

            SizedBox(width: 20),

            // user name
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}
