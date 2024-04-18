import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colabb/admin_pages/admin_mentorroom/add_usertile.dart';
import 'package:colabb/admin_pages/admin_mentorroom/circular_avatar.dart';
import 'package:colabb/admin_pages/admin_mentorroom/mentor_room.dart';
import 'package:colabb/admin_pages/admin_mentorroom/room_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateMentorRoom extends StatefulWidget {
  const CreateMentorRoom({super.key});

  @override
  State<CreateMentorRoom> createState() => _CreateMentorRoomState();
}

class _CreateMentorRoomState extends State<CreateMentorRoom> {
  TextEditingController _searchUserController = TextEditingController();
  List<Map<String, dynamic>> memberList = [];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool isCreateRoomLoading = false;
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    await _firestore
        .collection('Users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((map) {
      setState(() {
        memberList.add({
          'first name': map['first name'],
          'last name': map['last name'],
          'email': map['email'],
          'uid': map['uid'],
          'isadmin': true,
        });
      });
    });
  }

  void _onSearch() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection('Users')
        .where('first name', isEqualTo: _searchUserController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
    });
    _searchUserController.clear();
  }

  void onResultTap() {
    bool isAlreadyExist = false;
    for (int i = 0; i < memberList.length; i++) {
      if (memberList[i]['uid'] == userMap?['uid']) {
        isAlreadyExist = true;
      }
    }
    if (!isAlreadyExist) {
      setState(() {
        memberList.add({
          'first name': userMap?['first name'],
          'last name': userMap?['last name'],
          'email': userMap?['email'],
          'uid': userMap?['uid'],
          'isadmin': false
        });
        userMap = null;
      });
    }
  }

  void onRemoveMember(int index) {
    if (memberList[index]['uid'] != _auth.currentUser?.uid) {
      setState(() {
        memberList.removeAt(index);
      });
    }
  }

  void createRoom() async {
    setState(() {
      isCreateRoomLoading = true;
    });
    // List<String> ids = [];
    String chatRoomName = memberList[0]['first name'] + "'s chat_room";

    String? chatRoomID = _auth.currentUser?.uid;
    await _firestore.collection('mentor_rooms').doc(chatRoomID).set({
      'members': memberList,
      'chat_room_id': chatRoomID,
    });

    for (int i = 0; i < memberList.length; i++) {
      String uid = memberList[i]['uid'];

      await _firestore
          .collection('Users')
          .doc(uid)
          .collection('mentor_room')
          .doc(chatRoomID)
          .set({
        'name': chatRoomName,
        'chat_room_id': chatRoomID,
      });
    }

    await _firestore
        .collection('mentor_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add({
      'message': "${memberList[0]['first name']} created this group",
      'type': 'announce',
      'timeStamp': DateTime.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          "Add Students",
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            RoomTextField(
              onPressed: _onSearch,
              hintText: 'search students',
              obscureText: false,
              controller: _searchUserController,
            ),
            SizedBox(height: 20),
            memberList.isNotEmpty
                ? Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12)),
                      height: 130,
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: memberList.length,
                        itemBuilder: (context, index) {
                          return CircularAvatar(
                            onTap: () => onRemoveMember(index),
                            title: memberList[index]['first name'],
                          );
                        },
                      ),
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  )
                : userMap != null
                    ? AddUserTile(
                        onTap: onResultTap,
                        title: userMap?['first name'],
                      )
                    : SizedBox(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: memberList.length == 4
          ? isCreateRoomLoading
              ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                )
              : FloatingActionButton.extended(
                  onPressed: createRoom,
                  label: Text('Create Room'),
                )
          : SizedBox(),
    );
  }
}
