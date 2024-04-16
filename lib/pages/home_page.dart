import 'package:colabb/themes/theme_provider.dart';
import 'package:provider/provider.dart';

import 'mentor_grouppage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'assignments_page.dart';
import 'chat_page.dart';
import 'schedule_page.dart';
import 'profile_page.dart';
import '../services/auth/auth_service.dart';
import '../services/chat/chat_service.dart';
import '../components/user_tile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  static const String id = "homepageid";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  //chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      bottomNavigationBar: GNav(
        backgroundColor: isDarkMode
            ? ThemeData.dark().copyWith().canvasColor
            : ThemeData.light().copyWith().canvasColor,
        gap: 8,
        iconSize: 28,
        activeColor: Color(0XFF9e8cf2),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        tabMargin: EdgeInsets.all(10),
        duration: Duration(milliseconds: 500),
        tabBorderRadius: 12,
        textStyle: TextStyle(fontWeight: FontWeight.w300),
        tabBackgroundColor: isDarkMode
            ? ThemeData.dark().copyWith().highlightColor
            : ThemeData.light().copyWith().highlightColor,
        tabs: const [
          GButton(
            duration: Duration(seconds: 5),

            icon: Icons.dashboard_rounded,

            text: 'Home',
            // style: GnavStyle.oldSchool,
          ),
          GButton(
            icon: CupertinoIcons.list_bullet_below_rectangle,
            text: 'Assignments',
          ),
          GButton(
            icon: CupertinoIcons.clock_fill,
            text: 'Schedule',
          ),
          GButton(
            icon: CupertinoIcons.person_crop_square_fill,
            text: 'Mentor',
          )
        ],
        selectedIndex: _currentIndex,
        onTabChange: (index) {
          setState(() {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: IconButton(
                icon: const Icon(CupertinoIcons.gear),
                iconSize: 30,
                onPressed: () {
                  // navigate to settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                }),
          )
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
            return Center(child: CircularProgressIndicator());
          }

          //return list view
          return ListView(
            children: snapshot.data!
                .map<Widget>((userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        }),
      ),
    );
  }

  //build individual list tile for user
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    if (userData["email"] != _authService.getCurrentUser()?.email) {
      return UserTile(
        text: userData["name"],
        profilePicture: userData["profilePicture"] ?? "",
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
