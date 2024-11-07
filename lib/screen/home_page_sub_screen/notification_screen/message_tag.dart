import 'package:flutter/material.dart';

class MessageTag extends StatefulWidget {
  const MessageTag({super.key});

  @override
  State<MessageTag> createState() => _MessageTagState();
}

class _MessageTagState extends State<MessageTag> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Placeholder();
  }
}