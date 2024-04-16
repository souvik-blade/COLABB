import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colabb/models/mentorroom_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/message.dart';

class ChatService {
  // get instance of firestore & auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get user stream
  /*

  List<Map<String,Dynamic>>=
  [
    {
      'email': sou@gmail.com
      'id': ...
    },
    {
      'email': blade@gmail.com
      'id': ...
    }
  ]

  */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each individual user
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timeStamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timeStamp: timeStamp,
    );

    // construct a chat room ID for the two users(sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    //add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(
          newMessage.toMap(),
        );
  }

  // get message
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct a chat room ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }

  // send message in mentor room
  Future<void> sendMentorRoomMessage(String message, type, chatRoomID) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timeStamp = Timestamp.now();
    // create a new message
    MentorRoomMessage NewMentorRoomMessage = MentorRoomMessage(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      message: message,
      type: type,
      timeStamp: timeStamp,
    );
    //add new message to database
    await _firestore
        .collection('mentor_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(NewMentorRoomMessage.toMap());
  }

  // get mentor room message
  Stream<QuerySnapshot> getRoomMessages(String chatRoomID) {
    return _firestore
        .collection('mentor_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }

  // to check if a particular mentor_room exists or not
  Future<bool> mentorRoomExist(String chatRoomID) async {
    // Query 'mentor_rooms' collection to check if user is an admin
    QuerySnapshot mentorRoomSnapshot = await _firestore
        .collection('mentor_rooms')
        .where('chat_room_ID', isEqualTo: chatRoomID)
        .get();

    if (mentorRoomSnapshot.docs.isNotEmpty) {
      // mentor_room exists
      return true;
    } else {
      // does not exist
      return false;
    }
  }
}
