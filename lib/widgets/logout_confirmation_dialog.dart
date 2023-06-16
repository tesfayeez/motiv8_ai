import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoutConfirmationDialog {
  static Future<void> show(BuildContext context, VoidCallback onPressed) async {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      return showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Are you sure you want to log out?'),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the modal sheet
                  onPressed(); // Call the onPressed callback
                },
                child: Text('Yes'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          );
        },
      );
    } else {
      return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the modal sheet
                    onPressed(); // Call the onPressed callback
                  },
                  child: Text('Yes'),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
