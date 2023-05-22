import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/widgets/circular_progress.dart';
import 'package:motiv8_ai/widgets/task_panel_wiget.dart';

import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime goalDate;
  final String alarmTime;
  final String currentTime;
  final double percentage;

  GoalCard(
      {required this.title,
      required this.description,
      required this.goalDate,
      required this.alarmTime,
      required this.currentTime,
      required this.percentage});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.93;
    double height = MediaQuery.of(context).size.height * 0.15;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            10.0), // Adjust the radius to suit your needs.
      ),
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Goal Date: ${DateFormat.yMMMd().format(goalDate)}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircleProgress(percent: percentage),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 30.0, // Set the height
                  width: 90.0, // Set the width
                  child: ElevatedButton(
                      onPressed: () {
                        // Handle reschedule goal
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape: MaterialStateProperty.all(
                          const StadiumBorder(),
                        ),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(
                            0)), // remove padding to reduce the size of the button
                      ),
                      child: Text(
                        'Reschedule',
                        style: GoogleFonts.poppins(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.alarm,
                      color: Colors.blue,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      alarmTime,
                      style:
                          GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                    ),
                    const SizedBox(width: 8.0),
                    const Icon(
                      Icons.access_time,
                      color: Colors.blue,
                      size: 18,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      currentTime,
                      style:
                          GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
