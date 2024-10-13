import 'package:flutter/material.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key, required this.postId});

  final int postId;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            size: 30.0,
          ),
        ),
      ),
      body: const Center(
        child: Text("Page is in programming..."),
      ),
    );
  }
}
