import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import '../themes/theme_provider.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  static const String id = "settingsid";

  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
//to signout
  void logout() {
    // get auth service
    final auth = AuthService();
    auth.signOut();
  }

  String? imageUrl = '';
  String? uid = AuthService().getCurrentUser()?.uid;
  Future<String?> uploadProfilePicture(String userId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('$result.jpg');

      UploadTask uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        String downloadURL = await storageReference.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          'profilePicture': downloadURL,
        });

        print('Profile picture uploaded successfully!');
        // print(downloadURL);

        setState(() {
          imageUrl = downloadURL;
        });
        return downloadURL; // Return the download URL after uploading
      });
    }
    return null; // Return null if no file is selected
  }

  // void uploadAndFetchImageUrl(String userId) async {

  Future<String> getImageUrl(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data()
            as Map<String, dynamic>?; // Cast to expected type
        if (userData != null) {
          return userData['profilePicture'] as String;
        }
      }
    } catch (e) {
      print('Error fetching image URL: $e');
    }
    return "";
    // Return null if any error occurs
  }

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Users');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print(allData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // imageUrl = getImageUrl(uid!).toString();
    // getData();

    CollectionReference newCollection =
        FirebaseFirestore.instance.collection('Users');
    final documentReference = newCollection
        .where('uid', isEqualTo: uid)
        .get()
        .then((value) => print(value.docs[0]));
    // print(documentReference.snapshots());
  }

  void ger() async {
    DocumentSnapshot _documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_authService.getCurrentUser()!.uid)
        .get();
    print(_documentSnapshot);
    // String name = _documentSnapshot.data()!['name'];
  }

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Text(_authService.getCurrentUser()!.),
          CircleAvatar(
              maxRadius: 90,
              child:
                  // (imageUrl == null || imageUrl == "")
                  Icon(Icons.person)
              // : Image.network(
              //     imageUrl!,
              //     fit: BoxFit.contain,
              //   ),
              ),
          IconButton(
              onPressed: () {
                // uploadProfilePicture(uid!);
                // print(imageUrl);
                ger();
              },
              icon: Icon(CupertinoIcons.photo)),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.all(25.0),
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.all(25.0),
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Log Out",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    logout();
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.logout,
                  ),
                  iconSize: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
