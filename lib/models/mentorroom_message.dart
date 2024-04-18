import 'package:cloud_firestore/cloud_firestore.dart';

class MentorRoomMessage {
  final String senderID;
  final String senderEmail;
  final String message;
  final String type;
  final Timestamp timeStamp;
  final String firstName;

  MentorRoomMessage(
      {required this.senderID,
      required this.senderEmail,
      required this.message,
      required this.type,
      required this.timeStamp,
      required this.firstName});

  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderID,
      'first name': firstName,
      'senderEmail': senderEmail,
      'message': message,
      'type': type,
      'timeStamp': timeStamp,
    };
  }
}
