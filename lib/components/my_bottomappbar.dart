import 'package:colabb/pages/assignments_page.dart';
import 'package:colabb/pages/mentor_grouppage.dart';
import 'package:colabb/pages/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home_outlined),
            iconSize: 38,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.view_timeline_outlined),
            iconSize: 38,
            onPressed: () {
              Navigator.pushNamed(context, SchedulePage.id);
            },
          ),
          IconButton(
            icon: Icon(Icons.assignment_outlined),
            iconSize: 38,
            onPressed: () {
              Navigator.pushNamed(context, AssignmentPage.id);
            },
          ),
          IconButton(
              icon: Icon(Icons.group_outlined),
              iconSize: 38,
              onPressed: () {
                // tapped on mentor -> go to mentor page
                Navigator.pushNamed(context, MentorRoom.id);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => MentorRoom(
                //       mentorEmail: userData["email"],
                //       mentorID: userData["uid"],
                //     ),
                //   ),
                // );
              })
        ],
      ),
    );
  }
}
