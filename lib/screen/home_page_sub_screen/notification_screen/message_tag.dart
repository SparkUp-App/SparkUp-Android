import 'package:flutter/material.dart';
import 'package:spark_up/chat/chat_room_manager.dart';
import 'package:spark_up/common_widget/empty_view.dart';
import 'package:spark_up/common_widget/event_card_skeleton.dart';
import 'package:spark_up/data/list_rooms_received.dart';
import 'package:spark_up/route.dart';
import 'package:spark_up/common_widget/request_tag_skeleton.dart';

class MessageTag extends StatefulWidget {
  const MessageTag({super.key});

  @override
  State<MessageTag> createState() => _MessageTagState();
}

class _MessageTagState extends State<MessageTag>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

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
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: ChatRoomManager.manager.isLoading,
      builder: (context, isLoading, child) {
        return RefreshIndicator(
          onRefresh: ChatRoomManager.manager.refresh,
          child: Container(
            color: Colors.grey[50], // 淡灰色背景
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
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          for (var chatRoom in ChatRoomManager.manager.roomList.value) 
                            chatRoomCard(chatRoom),
                          if (isLoading) ...[const RequestSkeletonListRandomLength()],
                          if (ChatRoomManager.manager.error) 
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  "Something Went Wrong\nPlease Try Again Later",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget chatRoomCard(ChatListReceived chatRoom) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await Navigator.of(context).pushNamed(
            RouteMap.chatPage,
            arguments: (chatRoom.postId, chatRoom.postName),
          );
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatRoom.postName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    if (chatRoom.latestMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        "${chatRoom.latestMessage!.senderName}: ${chatRoom.latestMessage!.content}",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "temp mins ago",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (chatRoom.unreadCount != 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    chatRoom.unreadCount > 99 ? "99+" : "${chatRoom.unreadCount}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
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
