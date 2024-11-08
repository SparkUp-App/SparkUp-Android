import 'package:flutter/material.dart';

class RequestTag extends StatefulWidget {
  const RequestTag({super.key});

  @override
  State<RequestTag> createState() => _RequestTagState();
}

class _RequestTagState extends State<RequestTag> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Placeholder();
  }
}