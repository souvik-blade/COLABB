import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminAssignmentPage extends StatefulWidget {
  const AdminAssignmentPage({Key? key}) : super(key: key);

  @override
  State<AdminAssignmentPage> createState() => _AdminAssignmentPageState();
}

class _AdminAssignmentPageState extends State<AdminAssignmentPage> {
  late String selectedTitle = 'Mr.';
  late String _fileNameToShow = '';
  late File _fileDetail = File('');
  bool _uploading = false;
  final TextEditingController _assignedDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _facultyName = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  late DateTime _selectedDate;

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

  Future<void> _uploadAssignment(
      BuildContext context, String filename, File? file) async {
    String assDate = _assignedDateController.text;
    String dueDate = _dueDateController.text;
    String facultyName = _facultyName.text;
    String instructions = _instructionController.text;

    // Check if a PDF file is selected
    if (assDate.isNotEmpty &&
        dueDate.isNotEmpty &&
        facultyName.isNotEmpty &&
        instructions.isNotEmpty) {
      final reference = FirebaseStorage.instance.ref().child('pdfs/$filename.pdf');
      final uploadTask = reference.putFile(file!);
      await uploadTask.whenComplete(() {
        print('Uploaded');
      });
      final downloadLink = await reference.getDownloadURL();
      final DateTime uploadDateTime = DateTime.now();

      // Upload assignment details to Firestore
      await FirebaseFirestore.instance.collection('assignment').add({
        'assignedOn': assDate,
        'lastDate': dueDate,
        'facultyName': facultyName,
        'Instructions': instructions,
        'pdfUrl': downloadLink,
        'pdfName': _fileNameToShow,
        'uploadDateTime': uploadDateTime,
      });

      setState(() {
        _uploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Assignment uploaded successfully'),
        ),
      );

      _assignedDateController.clear();
      _instructionController.clear();
      _dueDateController.clear();
      _facultyName.clear();
    } else {
      // Upload assignment details to Firestore without PDF file
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill up all the details'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignedKey = GlobalKey();
    final deadlineKey = GlobalKey();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Assigned on",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                readOnly: true,
                key: assignedKey,
                controller: _assignedDateController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: "DD/MM/YYYY",
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101)
                      // withoutActionButtons: false,
                      // weekendDaysColor: Colors.red,
                      );
                  if (pickedDate != null) {
                    _selectedDate = pickedDate;
                    _assignedDateController.text =
                        DateFormat('d MMMM y').format(pickedDate);
                  }
                },
              ),

              const SizedBox(height: 30),
              const Text(
                "Last Date",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                key: deadlineKey,
                controller: _dueDateController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: "DD/MM/YYYY",
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    _selectedDate = pickedDate;
                    _dueDateController.text = DateFormat('d MMMM y').format(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 30),
              const Text(
                "Faculty name",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(height: 10),
              //faculty details
              Container(
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: DropdownButtonFormField<String>(
                        value: selectedTitle,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).colorScheme.tertiary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).colorScheme.primary),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          filled: true,
                          hintStyle:
                              TextStyle(color: Theme.of(context).colorScheme.primary),
                        ),
                        hint: const Text('Title'),
                        onChanged: (value) {
                          setState(() {
                            // selectedTitle = value.toString();
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Mr.',
                            child: Text('Mr.'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Mrs.',
                            child: Text('Mrs.'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _facultyName,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).colorScheme.tertiary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).colorScheme.primary),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          filled: true,
                          hintText: "Enter Name",
                          hintStyle:
                              TextStyle(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    "Instructions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _fileNameToShow,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                // height: 300,
                child: TextField(
                  maxLines: 8,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: "Enter the assignment details here....",
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  controller: _instructionController,
                ),
              ),
              if (_uploading)
                LinearProgressIndicator(
                  color: Color.fromARGB(255, 13, 143, 130),
                ),
              const SizedBox(height: 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // Adjust the value as needed
                      ),
                      height: 90,
                      minWidth: 120,
                      color: Color.fromARGB(255, 70, 62, 109),
                      child: const Text("Add PDF"),
                      onPressed: () async {
                        await pickFile();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // Adjust the value as needed
                      ),
                      height: 90,
                      minWidth: 120,
                      color: Color.fromARGB(255, 70, 62, 109),
                      onPressed: () async {
                        await _uploadAssignment(
                          context,
                          _fileNameToShow,
                          _fileDetail,
                        );
                      },
                      child: const Text("Upload"),
                    ),
                  ),
                ],
              ),
              // Show circular progress indicator while uploading
            ],
          ),
        ),
      ),
    );
  }
}
