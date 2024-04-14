import '../components/my_textfield.dart';
import 'package:flutter/material.dart';

class MentorRoom extends StatefulWidget {
  static const String id = "mentorroomid";
  // final String receiverEmail;
  // final String receiverID;
  MentorRoom({super.key});

  @override
  State<MentorRoom> createState() => _MentorRoomState();
}

class _MentorRoomState extends State<MentorRoom> {
  final TextEditingController _messageController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          "Mentor's Room",
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200),
        ),
        backgroundColor: Colors.transparent,
      ),
      // bottomNavigationBar: MyBottomAppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 32),
        alignment: Alignment.center,
        child: Column(
          children: [
            CircleAvatar(
              radius: 46,
            ),
            SizedBox(
              height: 16,
            ),
            Text("Mentor Name"),
            Container(
              padding: EdgeInsets.only(top: 42),
              child: _buildUserInput(),
            ),
          ],
        ),
      ),
    );
  }

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
              onPressed: () {},
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
