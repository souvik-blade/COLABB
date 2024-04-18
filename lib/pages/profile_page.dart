import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import '../themes/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  static const String id = "settingsid";

  const SettingsPage({Key? key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  String? imageUrl = '';
  String? uid = AuthService().getCurrentUser()?.uid;
  bool uploading = false;

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
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Users').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text('User not found.');
          } else {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final userFirstName = userData['first name'];
            final userLastName = userData['last name'];
            return Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      maxRadius: 90,
                      backgroundColor: Colors.grey[300],
                      child: _buildAvatarChild(userData['profilePicture']),
                    ),
                    if (uploading)
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          // valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          if (!uploading) {
                            uploadProfilePicture(uid!);
                          }
                        },
                        icon: Icon(
                          Icons.add_a_photo_rounded,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  '$userFirstName $userLastName',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.all(25.0),
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dark Mode",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Switch(
                        value:
                            Provider.of<ThemeProvider>(context, listen: false)
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.all(25.0),
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Log Out",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
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
            );
          }
        },
      ),
    );
  }

  Widget _buildAvatarChild(String? profilePicture) {
    if (profilePicture == null || profilePicture.isEmpty) {
      return Icon(
        CupertinoIcons.person_alt,
        size: 90,
        color: Colors.grey[600],
      );
    } else {
      return ClipOval(
        child: Image.network(
          profilePicture,
          width: 180,
          height: 180,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Future<void> uploadProfilePicture(String userId) async {
    setState(() {
      uploading = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String uniqueName = DateTime.now().toString();
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('$uniqueName.jpg');
      final imageBytes = await image.readAsBytes();

      UploadTask uploadTask = storageReference.putData(imageBytes);

      await uploadTask.whenComplete(() async {
        String downloadURL = await storageReference.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          'profilePicture': downloadURL,
        });

        setState(() {
          imageUrl = downloadURL;
          uploading = false;
        });
      });
    }
  }
}
