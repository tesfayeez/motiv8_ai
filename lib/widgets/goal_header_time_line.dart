import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';

class GoalHeaderTimeline extends ConsumerWidget {
  final List<GoalTask> tasks;

  const GoalHeaderTimeline({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = ref.watch(themeProvider);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            DateFormat('MMM d, yyyy').format(task.date),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        DashedLine(),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      width: 2,
                      color: Colors.green,
                      height: 130,
                    ),
                    Flexible(
                      child: GoalTaskCardForHeaderWidget(
                        goalTask: task,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashedLine extends StatelessWidget {
  final int numDashes;
  final Color color;

  const DashedLine({this.numDashes = 58, this.color = Colors.green});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        numDashes,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            height: 2,
            width: 2,
            color: color,
          ),
        ),
      ),
    );
  }
}

class GoalTaskCardForHeaderWidget extends ConsumerWidget {
  final GoalTask goalTask;

  const GoalTaskCardForHeaderWidget({required this.goalTask});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue.shade50.withOpacity(0.5),
      ),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  goalTask.name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  goalTask.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
