import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/widgets/add_goals_text_field.dart';
import 'package:motiv8_ai/widgets/custom_date_picker.dart';

class AddTaskDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Task',
        style: GoogleFonts.poppins(),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            GoalsTextField(
              controller: nameController,
              hintText: 'Task Name',
            ),
            const SizedBox(
              height: 5,
            ),
            GoalsTextField(
                controller: descriptionController, hintText: 'Description'),
            const SizedBox(
              height: 5,
            ),
            CustomDatePicker(
              controller: dateController,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel', style: GoogleFonts.poppins()),
        ),
        ElevatedButton(
          onPressed: () {
            // Perform the action for adding the task here
            String name = nameController.text;
            String description = descriptionController.text;
            String date = dateController.text;

            // Add your logic to handle the task creation

            Navigator.of(context).pop(); // Close the dialog
          },
          child:
              Text('Add Task', style: GoogleFonts.poppins(color: Colors.white)),
        ),
      ],
    );
  }
}
