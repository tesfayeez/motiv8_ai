import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/models/goals_model.dart';

import 'package:step_progress_indicator/step_progress_indicator.dart';

class GoalCard extends StatefulWidget {
  final Goal goalModel;
  final DateTime goalDate;
  final String alarmTime;
  final String currentTime;
  final int percentage;

  GoalCard({
    required this.goalModel,
    required this.goalDate,
    required this.alarmTime,
    required this.currentTime,
    required this.percentage,
  });

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Path drawCircle(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    ));
    return path;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.93;
    double height = MediaQuery.of(context).size.height * 0.17;

    if (widget.percentage == 100) {
      _confettiController.play();
    }

    return GestureDetector(
      onTap: () {
        print("Clicked ${widget.goalModel.name}");
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalize(widget.goalModel.name),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            widget.goalModel.description,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Goal Date: ${DateFormat.yMMMd().format(widget.goalDate)}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircularStepProgressIndicator(
                            height: 70,
                            totalSteps: 10,
                            currentStep: widget.percentage,
                            width: 70,
                            roundedCap: (_, isSelected) => isSelected,
                          ),
                          // SizedBox(
                          //   height: 50,
                          //   width: 50,
                          //   child: CircleProgress(percent: percentage),
                          // ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Progress',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const Divider(),
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
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              shape: MaterialStateProperty.all(
                                const StadiumBorder(),
                              ),
                              padding: MaterialStateProperty.all(const EdgeInsets
                                      .all(
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
                            widget.alarmTime,
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: Colors.grey),
                          ),
                          const SizedBox(width: 8.0),
                          const Icon(
                            Icons.access_time,
                            color: Colors.blue,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            widget.currentTime,
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            if (widget.percentage == 100)
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  createParticlePath: drawCircle,
                  maximumSize: const Size(9, 9),
                  minimumSize: const Size(8, 8),
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
