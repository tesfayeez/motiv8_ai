import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum TaskBreakdown { daily, weekly, milestones }

class TaskBreakdownWidget extends StatefulWidget {
  final TextEditingController controller;

  TaskBreakdownWidget({required this.controller});

  @override
  _TaskBreakdownWidgetState createState() => _TaskBreakdownWidgetState();
}

class _TaskBreakdownWidgetState extends State<TaskBreakdownWidget> {
  TaskBreakdown _taskBreakdown = TaskBreakdown.daily;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<TaskBreakdown>(
          title: Text(
            'Daily tasks',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 18.0),
            ),
          ),
          value: TaskBreakdown.daily,
          groupValue: _taskBreakdown,
          onChanged: (TaskBreakdown? value) {
            setState(() {
              _taskBreakdown = value!;
              widget.controller.text = value.toString();
            });
          },
        ),
        RadioListTile<TaskBreakdown>(
          title: Text(
            'Weekly tasks',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 18.0),
            ),
          ),
          value: TaskBreakdown.weekly,
          groupValue: _taskBreakdown,
          onChanged: (TaskBreakdown? value) {
            setState(() {
              _taskBreakdown = value!;
              widget.controller.text = value.toString();
            });
          },
        ),
        RadioListTile<TaskBreakdown>(
          title: Text(
            'Milestones',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 18.0),
            ),
          ),
          value: TaskBreakdown.milestones,
          groupValue: _taskBreakdown,
          onChanged: (TaskBreakdown? value) {
            setState(() {
              _taskBreakdown = value!;
              widget.controller.text = value.toString();
            });
          },
        ),
      ],
    );
  }
}
