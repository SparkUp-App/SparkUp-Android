import 'package:flutter/material.dart';

class MyRatPreviewTag extends StatefulWidget {
  const MyRatPreviewTag({super.key, required this.userId});

  final int userId;

  @override
  State<MyRatPreviewTag> createState() => _MyRatPreviewTagState();
}

class _MyRatPreviewTagState extends State<MyRatPreviewTag>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Placeholder();
  }
}
