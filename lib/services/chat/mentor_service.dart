// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// //importing a group msg model.

// class MentorService {
//   // get instance of firestore & auth
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // send message
//   Future<void> sendMessage(String receiverID, message) async {
//     // get current user info
//     final String currentUserID = _auth.currentUser!.uid;
//     final String currentUserEmail = _auth.currentUser!.email!;
//     final Timestamp timeStamp = Timestamp.now();

//     // create a new message
//     Message newMessage = Message(
//       senderID: currentUserID,
//       senderEmail: currentUserEmail,
//       receiverID: receiverID,
//       message: message,
//       timeStamp: timeStamp,
//     );

//     // construct a chat room ID between mentor and students(sorted to ensure uniqueness)
//     // List<String> ids = [currentUserID, receiverID];
//     // ids.sort();
//     // String chatRoomID = ids.join('_');

//     //add new message to database
//     await _firestore
//         .collection("mentor_rooms")
//         .doc(MentorRoomID)
//         .collection("messages")
//         .add(
//           newMessage.toMap(),
//         );
//   }

//   // get message
//   Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
//     // construct a chat room ID for the two users
//     List<String> ids = [userID, otherUserID];
//     ids.sort();
//     String MentorRoomID = ids.join('_');

//     return _firestore
//         .collection("mentor_rooms")
//         .doc(MentorRoomID)
//         .collection("messages")
//         .orderBy("timeStamp", descending: false)
//         .snapshots();
//   }
// }
