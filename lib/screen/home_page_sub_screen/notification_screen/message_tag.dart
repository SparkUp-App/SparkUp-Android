import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MessageTag extends StatefulWidget {
  const MessageTag({super.key});

  @override
  State<MessageTag> createState() => _MessageTagState();
}

class _MessageTagState extends State<MessageTag>
    with AutomaticKeepAliveClientMixin {
  List<ValueNotifier<int>> dataList = [
    ValueNotifier<int>(1),
    ValueNotifier<int>(2)
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        color: Colors.white,
        child: ListView(
          children: [
            for (var data in dataList) ...[
              chatRoomCard(data),
            ],
            Center(
              child: ElevatedButton(
                onPressed: () => dataList[0].value = dataList[0].value + 1,
                child: const Icon(Icons.add),
              ),
            )
          ],
        ));
  }

  Widget chatRoomCard(ValueListenable<int> valueListenable) {
    return ValueListenableBuilder(
        valueListenable: valueListenable,
        builder: (context, value, child) {
          return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFADADAD)))),
              child: Stack(children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      child: Text(
                        "Event Title",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: const Text(
                        "Rebecca: Say Something",
                        style: TextStyle(
                            color: Color(0xFF4B4B4B),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "$value mins ago",
                        style: const TextStyle(
                            color: Color(0xFF7F7E7E),
                            fontSize: 10.0,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
                const Positioned(
                    right: 10.0,
                    child: Icon(
                      Icons.circle,
                      size: 10.0,
                      color: Colors.red,
                    ))
              ]));
        });
  }
}

//For Calculating Time Before Now
//
// Duration differTime =
// DateTime.now().difference(widget.comment.lastUpdateDate);
// int monthsDiff =
//     (DateTime.now().year - widget.comment.lastUpdateDate.year) * 12 +
//         DateTime.now().month -
//         widget.comment.lastUpdateDate.month;
// if (differTime.inSeconds < 60) {
//   timeAfter = "${differTime.inSeconds} seconds ago";
// } else if (differTime.inMinutes < 60) {
//   timeAfter = "${differTime.inMinutes} minutes ago";
// } else if (differTime.inHours < 60) {
//   timeAfter = "${differTime.inHours} hours ago";
// } else if (differTime.inDays < 7) {
//   timeAfter = "${differTime.inDays} days ago";
// } else if (differTime.inDays < 30) {
//   timeAfter = "${(differTime.inDays / 7).floor()} weeks ago";
// } else if (monthsDiff < 12) {
//   timeAfter = "$monthsDiff months ago";
// } else {
//   timeAfter = "${(monthsDiff / 12).floor()} years ago";
// }