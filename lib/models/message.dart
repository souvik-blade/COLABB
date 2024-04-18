import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timeStamp;
  final String type;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timeStamp,
    required this.type,
  });

  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'timeStamp': timeStamp,
      'type': type
    };
  }
}
