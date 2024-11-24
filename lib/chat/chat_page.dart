import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:spark_up/common_widget/spark_Icon.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.postId, required this.postName});

  final int postId;
  final String postName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50.0,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 8.0),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFFF77D43),
            size: 35.0,
          ),
        ),
        titleSpacing: 0.0,
        title: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Text(
              widget.postName,
              style: const TextStyle(
                  color: Color(0xFFF77D43),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            )),
        actions: [
          IconButton(
              onPressed: () {/*Meun Process */},
              icon: const SparkIcon(
                icon: SparkIcons.bars,
                color: Color(0xFFF77D43),
              ))
        ],
      ),
      body: const Placeholder(),
    );
  }
}
