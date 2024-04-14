import 'package:colabb/pages/pdf_view.dart';
import 'package:flutter/material.dart';

class AssignmentTile extends StatelessWidget {
  final String assignedDate;
  final String dueDate;
  final String aboutAssignment;
  final String facultyName;
  final String pdfUrl;
  const AssignmentTile({
    super.key,
    required this.assignedDate,
    required this.dueDate,
    required this.aboutAssignment,
    required this.facultyName,
    required this.pdfUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      padding: const EdgeInsets.all(20),
      child: ExpansionTile(
        // trailing: Icon(Icons.picture_as_pdf),
        subtitle: Text('Last Date: $dueDate'),
        // backgroundColor: Colors.transparent,
        // backgroundColor: Colors.red,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),

        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Icon(Icons.picture_as_pdf_outlined),

            Text(
              facultyName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
            const SizedBox(
              width: 20,
            ),
            // const Icon(Icons.picture_as_pdf_outlined)
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    assignedDate,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.picture_as_pdf_rounded),
                    onPressed: pdfUrl != null && pdfUrl.isNotEmpty
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PdfView(pdfUrl: pdfUrl),
                              ),
                            );
                          }
                        : null, // Disable button if pdfUrl is null or empty
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(aboutAssignment),
            ],
          ),
        ],
      ),
    );
  }
}
