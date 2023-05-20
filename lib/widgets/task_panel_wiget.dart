import 'package:flutter/material.dart';

class TaskPanel extends StatefulWidget {
  final List<String> tasks;

  const TaskPanel({Key? key, required this.tasks}) : super(key: key);

  @override
  _TaskPanelState createState() => _TaskPanelState();
}

class _TaskPanelState extends State<TaskPanel> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      child: ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: const EdgeInsets.all(0),
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            this.isExpanded = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                title: Text(
                  'Tasks:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              );
            },
            body: ListView.builder(
              shrinkWrap:
                  true, // this is needed to prevent infinite height error
              itemCount: widget.tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    widget.tasks[index],
                    style: const TextStyle(fontSize: 14.0),
                  ),
                );
              },
            ),
            isExpanded: isExpanded,
          ),
        ],
      ),
    );
  }
}
