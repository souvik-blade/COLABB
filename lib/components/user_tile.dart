import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String profilePicture;
  final void Function()? onTap;
  const UserTile({super.key, required this.text, required this.onTap, required this.profilePicture});

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
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            // icon
            CircleAvatar(
              // foregroundColor: Colors.red,

              backgroundColor: Colors.grey[300], // Set a default background color
              child: (profilePicture == '')
                  ? // Ensure the image is properly fit within the circle
                  Icon(
                      size: 24,
                      CupertinoIcons.person_alt,
                    )
                  : ClipOval(
                      child: Image.network(
                        profilePicture,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            SizedBox(width: 20),

            // user name
            Text(
              text,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
