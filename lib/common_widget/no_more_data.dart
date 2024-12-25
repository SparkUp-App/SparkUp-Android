import 'package:flutter/material.dart';

class NoMoreData extends StatelessWidget {
  const NoMoreData({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cancel,
              size: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "No More Data!",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
