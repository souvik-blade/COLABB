import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // instance of auth & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      // sign user in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // // save user info if it doesn't already exist
      // _firestore.collection("Users").doc(userCredential.user!.uid).set(
      //   {
      //     'uid': userCredential.user!.uid,
      //     "email": email,
      //   },
      // );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign up
  Future<UserCredential> signUpWithEmailPassword(
      String email, password, firstName, lastName) async {
    try {
      // create user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info in a separate doc
      await _firestore.collection("Users").doc(userCredential.user?.uid).set(
        {
          'uid': userCredential.user?.uid,
          "email": email,
          'first name': firstName,
          'last name': lastName,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // sign in as an admin
  Future<UserCredential> adminSignInWithEmailPassword(
    String email,
    password,
  ) async {
    try {
      // sign admin in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // to check if the user is an admin or not
  Future<bool> isAdmin(User user) async {
    // Query 'admins' collection to check if user is an admin
    QuerySnapshot adminSnapshot = await _firestore
        .collection('admins')
        .where('uid', isEqualTo: user.uid)
        .get();

    if (adminSnapshot.docs.isNotEmpty) {
      // User is an admin
      return true;
    } else {
      // User is not an admin

      // Implement logic to check if user is an admin
      // For example, query Firestore to check if user is in admin collection
      // Return true if user is admin, false otherwise
      return false;
    }
  }

// // to check if the user has its name stored in the database
//   Future<bool> checkUserDetails(User user) async {
//     final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
//         await FirebaseFirestore.instance
//             .collection('Users')
//             .doc(user.uid)
//             .get();

//     final userData = userSnapshot.data();
//     final storedFirstName = userData?['first name'];
//     final storedLastName = userData?['last name'];

//     if (storedFirstName == null ||
//         storedFirstName.isEmpty ||
//         storedLastName == null ||
//         storedLastName.isEmpty) {
//       return false;
//     } else {
//       return true;
//     }
//   }

//   void setUserDetails(User user, String firstName, lastName) async {
//     await _firestore.collection('Users').doc(user.uid).set(
//       {
//         'first name': firstName,
//         'last name': lastName,
//       },
//     );
//   }

  //errors
}
