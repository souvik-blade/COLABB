import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colabb/components/upload_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vph_web_date_picker/vph_web_date_picker.dart';
import 'package:intl/intl.dart';

class AdminAssignmentPage extends StatefulWidget {
  AdminAssignmentPage({super.key});

  @override
  State<AdminAssignmentPage> createState() => _AdminAssignmentPageState();
}

class _AdminAssignmentPageState extends State<AdminAssignmentPage> {
  final TextEditingController _assignedDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _facultyName = TextEditingController();

  final TextEditingController _instructionController = TextEditingController();

  Future<void> _uploadAssignnemt(BuildContext context) async {
    String assDate = _assignedDateController.text;
    String dueDate = _dueDateController.text;
    String facultyName = _facultyName.text;
    String instructions = _instructionController.text;

    if (assDate.isNotEmpty &&
        dueDate.isNotEmpty &&
        facultyName.isNotEmpty &&
        instructions.isNotEmpty) {
      await FirebaseFirestore.instance.collection('assignment').add({
        'assignedOn': assDate,
        'lastDate': dueDate,
        'facultyName': facultyName,
        'Instructions': instructions,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assignment uploaded successfully')),
      );

      _assignedDateController.clear();
      _instructionController.clear();
      _dueDateController.clear();
      _facultyName.clear();
    } else {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  late TextEditingController _controller;
  late DateTime _selectedDate;
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _controller =
        TextEditingController(text: _selectedDate.toString().split(' ')[0]);
  }

  late String selectedTitle = 'Mr.';
  @override
  Widget build(BuildContext context) {
    final assignedKey = GlobalKey();
    final deadlineKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Assignment'),
      ),
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
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: "DD/MM/YYYY",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
                onTap: () async {
                  final pickedDate = await showWebDatePicker(
                    context: assignedKey.currentContext!,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 7)),
                    lastDate: DateTime.now().add(const Duration(days: 14000)),
                    width: 300,
                    withoutActionButtons: false,
                    weekendDaysColor: Colors.red,
                  );
                  if (pickedDate != null) {
                    _selectedDate = pickedDate;
                    _assignedDateController.text =
                        DateFormat('d\'th\' MMMM y').format(pickedDate);
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Last Date",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                key: deadlineKey,
                controller: _dueDateController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: "DD/MM/YYYY",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
                onTap: () async {
                  final pickedDate = await showWebDatePicker(
                    context: deadlineKey.currentContext!,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 7)),
                    lastDate: DateTime.now().add(const Duration(days: 14000)),
                    width: 300,
                    withoutActionButtons: false,
                    weekendDaysColor: Colors.red,
                  );
                  if (pickedDate != null) {
                    _selectedDate = pickedDate;
                    _dueDateController.text =
                        DateFormat('d\'th\' MMMM y').format(pickedDate);
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Faculty name",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(
                height: 10,
              ),
              //faculty details

              Container(
                // color: Colors.red,
                width: double.maxFinite,
                // height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: DropdownButtonFormField<String>(
                        value: selectedTitle,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            fillColor: Theme.of(context).colorScheme.secondary,
                            filled: true,
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary)),
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
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            fillColor: Theme.of(context).colorScheme.secondary,
                            filled: true,
                            hintText: "Enter Name",
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary)),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              const Text(
                "Instructions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 300,
                child: TextField(
                  maxLines: 8,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      hintText: "Enter the assignment details here....",
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                  controller: _instructionController,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: UploadButton(
                        text: "Upload Assignment",
                        onTap: () {
                          _uploadAssignnemt(context);
                        }),
                  ),
                  UploadButton(
                      text: "Add PDF",
                      onTap: () {
                        print("");
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
