import 'package:flutter/material.dart';

class ParticipatedPage extends StatefulWidget {
  const ParticipatedPage({super.key, required this.userId});

  final int userId;

  @override
  State<ParticipatedPage> createState() => _ParticipatedPageState();
}

class _ParticipatedPageState extends State<ParticipatedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          "Participated",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF7AF8B),
      ),
      body: const Placeholder(),
    );
  }
}
