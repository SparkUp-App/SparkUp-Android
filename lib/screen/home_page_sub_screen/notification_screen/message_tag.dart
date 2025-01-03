import 'package:flutter/material.dart';
import 'package:spark_up/chat/chat_room_manager.dart';
import 'package:spark_up/common_widget/empty_view.dart';
import 'package:spark_up/common_widget/event_card_skeleton.dart';
import 'package:spark_up/common_widget/request_tag_skeleton.dart';
import 'package:spark_up/data/list_rooms_received.dart';
import 'package:spark_up/route.dart';

class MessageTag extends StatefulWidget {
  const MessageTag({super.key});

  @override
  State<MessageTag> createState() => _MessageTagState();
}

class _MessageTagState extends State<MessageTag> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        ChatRoomManager.manager.getData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        ChatRoomManager.manager.getData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ChatRoomManager.manager.isLoading,
      builder: (context, isLoading, child) {
        return RefreshIndicator(
          onRefresh: ChatRoomManager.manager.refresh,
          child: ChatRoomManager.manager.roomList.value.isEmpty && !isLoading
              ? const EmptyView(
                  content:
                      "Join an event then you can chat with others in this place.")
              : ValueListenableBuilder(
                  valueListenable: ChatRoomManager.manager.roomList,
                  builder: (context, value, child) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      children: [
                        for (var chatRoom in ChatRoomManager.manager.roomList
                            .value) ...[chatRoomCard(chatRoom)],
                        if (isLoading) ...[
                          const RequestSkeletonListRandomLength()
                        ],
                        if (ChatRoomManager.manager.error) ...[
                          const EmptyView(
                            content:
                                "Something Went Wrong\n Please Try Again Later",
                          )
                        ],
                      ],
                    );
                  },
                ),
        );
      },
    );
  }

  Widget chatRoomCard(ChatListReceived chatRoom) {
    return GestureDetector(
        onTap: () async {
          await Navigator.of(context).pushNamed(RouteMap.chatPage,
              arguments: (chatRoom.postId, chatRoom.postName));
          setState(() {});
        },
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFADADAD)))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text(
                            chatRoom.postName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (chatRoom.latestMessage != null) ...[
                          Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "${chatRoom.latestMessage!.senderName}: ${chatRoom.latestMessage!.content}",
                              style: const TextStyle(
                                  color: Color(0xFF4B4B4B),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              timeAfterCalculate(
                                  chatRoom.latestMessage!.createTime),
                              style: const TextStyle(
                                  color: Color(0xFF7F7E7E),
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (chatRoom.unreadCount != 0) ...[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 25.0,
                          color: Colors.red,
                        ),
                        Text(
                          chatRoom.unreadCount > 99
                              ? "99+"
                              : "${chatRoom.unreadCount}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ]
                ])));
  }
}

String timeAfterCalculate(DateTime targetTime) {
  String timeAfter;
  Duration differTime = DateTime.now().difference(targetTime);
  int monthsDiff = (DateTime.now().year - targetTime.year) * 12 +
      DateTime.now().month -
      targetTime.month;
  if (differTime.inSeconds < 60) {
    timeAfter = "just now";
  } else if (differTime.inMinutes < 60) {
    timeAfter = "${differTime.inMinutes} minutes ago";
  } else if (differTime.inHours < 60) {
    timeAfter = "${differTime.inHours} hours ago";
  } else if (differTime.inDays < 7) {
    timeAfter = "${differTime.inDays} days ago";
  } else if (differTime.inDays < 30) {
    timeAfter = "${(differTime.inDays / 7).floor()} weeks ago";
  } else if (monthsDiff < 12) {
    timeAfter = "$monthsDiff months ago";
  } else {
    timeAfter = "${(monthsDiff / 12).floor()} years ago";
  }
  return timeAfter;
}
