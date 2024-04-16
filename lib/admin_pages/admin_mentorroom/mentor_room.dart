import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colabb/admin_pages/admin_mentorroom/create_room.dart';
import 'package:colabb/components/chat_bubble.dart';
import 'package:colabb/components/my_button.dart';
import 'package:colabb/components/my_textfield.dart';
import 'package:colabb/services/auth/auth_service.dart';
import 'package:colabb/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MentorRoomScreen extends StatefulWidget {
  MentorRoomScreen({super.key});

  @override
  State<MentorRoomScreen> createState() => _MentorRoomScreenState();
}

class _MentorRoomScreenState extends State<MentorRoomScreen> {
  // text controller
  final TextEditingController _messageController = TextEditingController();
  AuthService _authService = AuthService();
  ChatService _chatService = ChatService();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // cause a delay so that the keyboard has time to show up
        //then the amount of remaining space will be calculated,
        //the scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    // wait a bit for listview to be built, then scrollto bottom
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // send message
  void sendmessage() async {
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMentorRoomMessage(
          _messageController.text, 'text', _authService.getCurrentUser()!.uid);

      // clear text controller
      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMessageList(),
    );
  }

  // build message list
  Widget _buildMessageList() {
    String chatRoomID = _authService.getCurrentUser()!.uid;
    // return FutureBuilder(
    //   future: _chatService.mentorRoomExist(chatRoomID),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       // Future hasn't completed yet, show a loading indicator or placeholder
    //       return CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       // Error occurred while checking for mentor room existence
    //       return Text("Error: ${snapshot.error}");
    //     } else if (snapshot.data == true) {
    //       // Mentor room exists, return the stream builder for messages
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: _chatService.getRoomMessages(chatRoomID),
            builder: (context, snapshot) {
              // Remaining code for StreamBuilder...
              // errors
              if (snapshot.hasError) {
                return const Text("Error");
              }

              // loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              // return list view
              return ListView(
                controller: _scrollController,
                children: snapshot.data!.docs
                    .map((doc) => _buildMessageItem(doc))
                    .toList(),
              );
            },
          ),
        ),
        _buildUserInput(),
      ],
    );
    //     } else {
    //       // Mentor room does not exist, display message and create room button
    //       return Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text(
    //             'No students Assigned',
    //             style: TextStyle(fontSize: 24),
    //           ),
    //           SizedBox(height: 20),
    //           MyButton(
    //             text: 'Create Room',
    //             onTap: () {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) => CreateMentorRoom(),
    //                 ),
    //               );
    //             },
    //           ),
    //         ],
    //       );
    //     }
    //   },
    // );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    User loggedInUser = _authService.getCurrentUser()!;
    bool isCurrentUser = data['senderId'] == loggedInUser.uid;

    // align message to the right if sender is the current user, otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
            type: data['type'],
          )
        ],
      ),
    );
  }

  //build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // textfield should take upmost of the space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: sendmessage,
              icon: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}












  // return Scaffold(
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //           'No students Assigned',
  //           style: TextStyle(fontSize: 24),
  //         ),
  //         SizedBox(height: 20),
  //         MyButton(
  //             text: 'Create Room',
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => CreateMentorRoom(),
  //                 ),
  //               );
  //             }),
  //       ],
  //     ),
  //   );



  