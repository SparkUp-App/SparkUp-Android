import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String message; // String parameter for the message

  // Constructor to accept the message
  const NoteCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F0),  // Light orange background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE9765B).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom:4.0),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE9765B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: Color(0xFFE9765B),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message, // Use the passed message
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFE9765B),
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        
        ],
      ),
    )
      );
  }
}
