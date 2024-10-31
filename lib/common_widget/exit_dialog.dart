import 'package:flutter/material.dart';
import 'dart:io';

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: 8),
          const Text(
            '確定要離開?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: const Text(
        '您確定要離開應用程式嗎?',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            foregroundColor: Colors.grey,
          ),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () => exit(0),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('確定'),
        ),
      ],
    );
  }
}