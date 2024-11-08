import 'package:flutter/material.dart';

class TorateTag extends StatefulWidget {
  const TorateTag({super.key, required this.userId});

  final int userId;

  @override
  State<TorateTag> createState() => _TorateTagState();
}

class _TorateTagState extends State<TorateTag>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Placeholder();
  }
}
