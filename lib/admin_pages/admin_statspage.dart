// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminStatsPage extends StatefulWidget {
  const AdminStatsPage({Key? key}) : super(key: key);

  @override
  State<AdminStatsPage> createState() => _AdminStatsPageState();
}

class _AdminStatsPageState extends State<AdminStatsPage> {
  late String _fileNameToShow = '';
  late File _fileDetail;
  bool _uploading = false;

  // Upload PDF
  Future<void> uploadPdf(String filename, File file) async {
    setState(() {
      _uploading = true; // Start uploading, show progress indicator
    });

    final reference = FirebaseStorage.instance.ref().child('pdfs/$filename.pdf');
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {
      print('Uploaded');
    });
    final downloadLink = await reference.getDownloadURL();
    await FirebaseFirestore.instance.collection('pdfs').add({
      'name': _fileNameToShow,
      'downloadUrl': downloadLink,
      'timestamp': DateTime.now(),
    });
    // Clear picked file after upload
    setState(() {
      // _fileDetail = null;
      _fileNameToShow = '';
    });
    setState(() {
      _uploading = false; // Upload finished, hide progress indicator
    });

    print('Download link: $downloadLink');
  }

  // Pick PDF
  Future<void> pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      String fileName = pickedFile.files.single.name;
      setState(() {
        _fileNameToShow = fileName;
        _fileDetail = File(pickedFile.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.red,
              child: const Text("Add Pdf"),
              onPressed: () async {
                print(DateTime.now());
              },
            ),
            const SizedBox(height: 20),
            Text(
              _fileNameToShow,
              style: TextStyle(fontSize: 18),
            ),
            MaterialButton(
              color: Colors.red,
              child: const Text("Upload Pdf"),
              onPressed: _uploading
                  ? null
                  : () async {
                      await uploadPdf(_fileNameToShow, _fileDetail);
                    },
            ),
            if (_uploading)
              SizedBox(
                child:
                    CircularProgressIndicator(), // Show progress indicator while uploading
              ),
          ],
        ),
      ),
    );
  }
}
