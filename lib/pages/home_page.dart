import 'package:colabb/components/my_bottomappbar.dart';
import 'package:colabb/components/user_tile.dart';
import 'package:colabb/pages/chat_page.dart';
import 'package:colabb/pages/settings_page.dart';
import 'package:colabb/services/auth/auth_service.dart';
import 'package:colabb/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.transparent,
        // foregroundColor: Colors.grey,
        //actions: [Text(_authService.getCurrentUser()!.email!)],
        actions: [
          IconButton(
              icon: Icon(Icons.settings_outlined),
              iconSize: 38,
              onPressed: () {
                // navigate to settings page
                Navigator.pushNamed(context, SettingsPage.id);
              })
        ],
      ),
      // drawer: MyDrawer(),
      bottomNavigationBar: MyBottomAppBar(),

      body: _buildUserList(),
    );
  }

  //build a list of users except for the current user.
  Widget _buildUserList() {
    return StreamBuilder(
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
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      }),
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
