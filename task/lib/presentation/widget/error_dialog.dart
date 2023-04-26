import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MaterialErrorDialog extends StatelessWidget {
  final String title;
  final String content;

  const MaterialErrorDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('OK'),
        )
      ],
    );
  }
}

class CupertinoErrorDialog extends StatelessWidget {
  final String title;
  final String content;

  const CupertinoErrorDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('OK'),
        )
      ],
    );
  }
}
