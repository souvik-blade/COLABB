import 'package:colabb/pages/mentor_grouppage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:colabb/pages/assignments_page.dart';
import 'package:colabb/pages/chat_page.dart';
import 'package:colabb/pages/schedule_page.dart';
import 'package:colabb/pages/settings_page.dart';
import 'package:colabb/services/auth/auth_service.dart';
import 'package:colabb/services/chat/chat_service.dart';
import 'package:provider/provider.dart';

import '../components/user_tile.dart';
import '../themes/theme_provider.dart';

class HomePage extends StatefulWidget {
  static const String id = "homepageid";

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  //chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //theme data

  final _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined,
          color: Color.fromARGB(255, 105, 98, 98), size: 30),
      activeIcon:
          Icon(Icons.dashboard_rounded, size: 30, color: Colors.blueAccent),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.time,
          color: Color.fromARGB(255, 105, 98, 98), size: 30),
      activeIcon:
          Icon(CupertinoIcons.time_solid, size: 30, color: Colors.blueAccent),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.list_bullet_below_rectangle,
          color: Color.fromARGB(255, 105, 98, 98), size: 30),
      activeIcon: Icon(CupertinoIcons.list_bullet_indent,
          size: 30, color: Colors.blueAccent),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.person_crop_square,
          color: Color.fromARGB(255, 105, 98, 98), size: 30),
      activeIcon: Icon(CupertinoIcons.person_crop_square_fill,
          size: 30, color: Colors.blueAccent),
      label: "Home",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: _currentIndex,
        items: _bottomNavigationBarItems,
        onTap: (index) {
          setState(() {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn);
          });
        },
      ),
      body: PageView(
          controller: _pageController,
          onPageChanged: (newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          children: [
            _buildUserList(),
            const AssignmentPage(),
            const SchedulePage(),
            MentorRoom(),
          ]),
    );
  }

  //build a list of users except for the current user.
  Widget _buildUserList() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200),
        ),
        backgroundColor: Colors.transparent,
        // foregroundColor: Colors.grey,
        //actions: [Text(_authService.getCurrentUser()!.email!)],
        actions: [
          IconButton(
              icon: const Icon(CupertinoIcons.gear),
              iconSize: 30,
              onPressed: () {
                // navigate to settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              })
        ],
      ),
      body: StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: ((context, snapshot) {
          //error
          if (snapshot.hasError) {
            return const Text("Error");
          }

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          //return list view
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        }),
      ),
    );
  }

  //build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          // tapped on a user -> go to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
