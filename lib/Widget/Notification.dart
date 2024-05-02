import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  // final String title;
  final String content;

  const NotificationDialog({
    // required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(content),
    );
  }




}
