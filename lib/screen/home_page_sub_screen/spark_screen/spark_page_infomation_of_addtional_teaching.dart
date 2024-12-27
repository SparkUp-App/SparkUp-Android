import 'package:flutter/material.dart';

class SparkPageInformationOfAdditionalTeaching extends StatelessWidget {
  const SparkPageInformationOfAdditionalTeaching({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Additional Teaching Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to the Additional Teaching Information page!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Here you can find resources and guides to support your teaching journey.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Feel free to explore the links below for more details.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Replace with your URL handling logic
                print('Navigating to resource 1...');
              },
              child: const Text(
                'Resource 1: Teaching Strategies',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Replace with your URL handling logic
                print('Navigating to resource 2...');
              },
              child: const Text(
                'Resource 2: Classroom Activities',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
