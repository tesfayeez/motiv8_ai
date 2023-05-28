import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/widgets/custom_checkbox.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';

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
  bool _isSelected = false;

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
    double height = MediaQuery.of(context).size.height * 0.15;

    if (widget.percentage == 100) {
      _confettiController.play();
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          print("Clicked ${widget.goalModel.name}");
        },
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomCheckbox(
                            value: _isSelected,
                            onChanged: (bool newValue) {
                              setState(() {
                                _isSelected = newValue;
                              });
                            },
                          ),
                          const SizedBox(width: 5.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2.0),
                              Text(
                                capitalize(widget.goalModel.name),
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                capitalize(widget.goalModel.description),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                'Goal Date: ${DateFormat.yMMMd().format(widget.goalDate)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 15.0),
                              CircularStepProgressIndicator(
                                unselectedColor: Colors.black,
                                height: 55,
                                totalSteps: 10,
                                currentStep: 2,
                                width: 55,
                                roundedCap: (_, isSelected) => isSelected,
                              ),
                            ],
                          ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
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
              Positioned(
                right: 1,
                top: -8,
                child: IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.7),
                      builder: (context) {
                        return SimpleDialog(
                          title: Text('Options'),
                          children: [
                            SimpleDialogOption(
                              onPressed: () {
                                // edit goal
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Edit goal'),
                                  Icon(Icons.edit),
                                ],
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                // duplicate goal
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Duplicate goal'),
                                  Icon(Icons.content_copy),
                                ],
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                // complete goal
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Complete goal'),
                                  Icon(Icons.check_circle),
                                ],
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                // delete goal
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Delete goal',
                                    style:
                                        GoogleFonts.poppins(color: Colors.red),
                                  ),
                                  Icon(Icons.delete, color: Colors.red),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
