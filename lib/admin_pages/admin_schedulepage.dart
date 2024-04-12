import 'package:colabb/themes/theme_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScheduleUploadScreen extends StatefulWidget {
  const AdminScheduleUploadScreen({super.key});

  @override
  State<AdminScheduleUploadScreen> createState() =>
      _AdminScheduleUploadScreenState();
}

class _AdminScheduleUploadScreenState extends State<AdminScheduleUploadScreen> {
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _weekdayController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  //  AdminScheduleUploadScreen({super.key});
  void _uploadSchedule(BuildContext context, String weekday) async {
    String from = _fromTimeController.text;
    String to = _toTimeController.text;
    String subject = _subjectController.text;

    if (from.isNotEmpty && to.isNotEmpty && subject.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('schedule')
          .doc('mACbTDRVDbztXYb8g9Js')
          .collection(weekday)
          .add({'from': from, 'to': to, 'subject': subject});

      // Show success message or navigate back to previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule uploaded successfully')),
      );

      // Clear the text fields after uploading
      _fromTimeController.clear();
      _subjectController.clear();
    } else {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  //show time picker
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

//week picker
  final List<String> weekdays = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday'
  ];

  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "From",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(
                height: 10,
              ),
              //from text field
              TextField(
                // readOnly: true,
                controller: _fromTimeController,
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
                    hintText: "HH:MM",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null && picked != _selectedTime) {
                    _selectedTime = picked;
                    String formattedHour = _selectedTime.hour < 10
                        ? '0${_selectedTime.hour}'
                        : '${_selectedTime.hour}';
                    String formattedMinute = _selectedTime.minute < 10
                        ? '0${_selectedTime.minute}'
                        : '${_selectedTime.minute}';
                    _fromTimeController.text =
                        "$formattedHour:$formattedMinute";
                  }
                },
              ),

              const SizedBox(
                height: 30,
              ),
              const Text(
                "To",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(
                height: 10,
              ),
              // to text field
              TextField(
                // readOnly: true,
                controller: _toTimeController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: "HH:MM",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null && picked != _selectedTime) {
                    setState(() {
                      _selectedTime = picked;
                      String formattedHour = _selectedTime.hour < 10
                          ? '0${_selectedTime.hour}'
                          : '${_selectedTime.hour}';
                      String formattedMinute = _selectedTime.minute < 10
                          ? '0${_selectedTime.minute}'
                          : '${_selectedTime.minute}';
                      _toTimeController.text =
                          "$formattedHour:$formattedMinute";
                    });
                  }
                },
              ),

              // week text field
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Day",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary)),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: "Enter Name",
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                hint: const Text(
                  'Select Day',
                  style: TextStyle(fontSize: 14),
                ),
                items: weekdays
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select gender.';
                  }
                  return null;
                },
                onChanged: (value) {
                  // print(value);
                  setState(() {
                    _weekdayController.text = value.toString();
                  });
                  //Do something when selected item is changed.

                  // print(value);
                },
                onSaved: (value) {
                  _weekdayController.text = value.toString();
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(right: 8),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                  ),
                  iconSize: 24,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Subject",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _subjectController,
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
                    hintText: "Enter the subject",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () =>
                    _uploadSchedule(context, _weekdayController.text),
                // onPressed: () {
                //   print(_toTimeController.text);
                //   print(_fromTimeController.text);
                //   print(_weekdayController.text);
                //   print(_subjectController.text);

                // },
                child: const Text('Upload Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
