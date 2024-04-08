import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScheduleUploadScreen extends StatelessWidget {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  void _uploadSchedule(BuildContext context) async {
    String time = _timeController.text;
    String subject = _subjectController.text;

    if (time.isNotEmpty && subject.isNotEmpty) {
      await FirebaseFirestore.instance.collection('schedule').add({
        'time': time,
        'subject': subject,
      });

      // Show success message or navigate back to previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Schedule uploaded successfully')),
      );

      // Clear the text fields after uploading
      _timeController.clear();
      _subjectController.clear();
    } else {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _uploadSchedule(context),
              child: Text('Upload Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}
