import 'package:flutter/material.dart';
import 'package:spark_up/chat/chat_room_manager.dart';
import 'package:spark_up/chat/data/chat_message.dart';
import 'package:spark_up/common_widget/spark_Icon.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/chat_path.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.postId, required this.postName});

  final int postId;
  final String postName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isLoading = false;
  bool hasMoreMessage = true;
  int? oldestMessageId;
  final ScrollController _scrollController = ScrollController();
  final int limit = 50;
  late DateTime? currentMessageDate;

  ValueNotifier<List<ChatMessage>> messageList = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    readAll();
    ChatRoomManager.manager.currentPostId = widget.postId;
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        getMoreMessage();
      }
    });
    ChatRoomManager.manager.updateMessage.addListener(() {
      if (ChatRoomManager.manager.updateMessage.value != null) {
        currentMessageDate =
            ChatRoomManager.manager.updateMessage.value!.createdAt;
        messageList.value = [
          ChatRoomManager.manager.updateMessage.value!,
          ...messageList.value
        ];
      }
    });
    getMoreMessage();
  }

  @override
  void dispose() {
    super.dispose();
    readAll();
    ChatRoomManager.manager.currentPostId = null;
    _scrollController.removeListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        getMoreMessage();
      }
    });
    ChatRoomManager.manager.updateMessage.removeListener(() {
      if (ChatRoomManager.manager.updateMessage.value != null) {
        currentMessageDate =
            ChatRoomManager.manager.updateMessage.value!.createdAt;
        messageList.value = [
          ChatRoomManager.manager.updateMessage.value!,
          ...messageList.value
        ];
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    currentMessageDate =
        messageList.value.isEmpty ? null : messageList.value[0].createdAt;
  }

  void readAll() {
    int index = 0;
    for (index; index < ChatRoomManager.manager.roomCount; index++) {
      if (ChatRoomManager.manager.roomList.value[index].postId ==
          widget.postId) {
        break;
      }
    }
    if (index == ChatRoomManager.manager.roomCount) {
      debugPrint("Room Count Error");
      return;
    }

    ChatRoomManager.manager.roomList.value
        .firstWhere((element) => element.postId == widget.postId)
        .setunreadCount(0);

    Network.manager.sendRequest(
        method: RequestMethod.post,
        path: ChatPath.message,
        data: {
          "post_id": widget.postId,
          "user_id": Network.manager.userId,
          "limit": 1
        });
  }

  void getMoreMessage() async {
    if (isLoading || !hasMoreMessage) return;
    isLoading = true;
    setState(() {});

    final response = await Network.manager
        .sendRequest(method: RequestMethod.post, path: ChatPath.message, data: {
      "post_id": widget.postId,
      "user_id": Network.manager.userId,
      "before_id": oldestMessageId,
      "limit": limit
    });

    if (context.mounted) {
      if (response["status"] == "success") {
        messageList.value = [
          ...messageList.value,
          ...((response["data"]["messages"] as List<dynamic>)
              .map((element) => ChatMessage.initfromData(element))
              .toList())
        ];
        hasMoreMessage = response["data"]["has_more"];
        oldestMessageId = response["data"]["oldest_id"];
      } else {
        showDialog(
            context: context,
            builder: (context) => const SystemMessage(
                content: "Something Went Wrong\n Please Try Again Later"));
      }
    } else {
      return;
    }

    isLoading = false;
    setState(() {});
  }

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
        body: ValueListenableBuilder(
          valueListenable: messageList,
          builder: (context, messageList, child) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              reverse: true,
              children: [
                for (var message in messageList) ...[
                  if (currentMessageDate!.month != message.createdAt.month ||
                      currentMessageDate!.day != message.createdAt.day) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      child: dateBubble(message),
                    )
                  ],
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: chatBubble(message),
                  ),
                ],
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            );
          },
        ));
  }

  Widget chatBubble(ChatMessage message) {
    bool selfMessage = message.senderId == Network.manager.userId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            selfMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Row(
                mainAxisAlignment: selfMessage
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (selfMessage) ...[
                    Text(
                      "${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        color: Color(0xFF999998),
                        fontSize: 10.0,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                  ],
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: selfMessage
                            ? const Color(0xFFF77D43)
                            : const Color(0xFF999998),
                        borderRadius: selfMessage
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              )
                            : const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        message.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  if (!selfMessage) ...[
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        color: Color(0xFF999998),
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dateBubble(ChatMessage message) {
    DateTime needShowDate = currentMessageDate!;
    currentMessageDate = message.createdAt;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.black26.withOpacity(0.3)),
          child: Text(
            "${needShowDate.month}/${needShowDate.day} ${weekDayIntToString(needShowDate.weekday)}",
            style: const TextStyle(color: Colors.white, fontSize: 10.0),
          ),
        )
      ],
    );
  }
}

String weekDayIntToString(int day) {
  switch (day) {
    case 1:
      return "Mon.";
    case 2:
      return "Tue.";
    case 3:
      return "Wed.";
    case 4:
      return "Thur.";
    case 5:
      return "Fri.";
    case 6:
      return "Sat.";
    case 7:
      return "Sun.";
    default:
      return "Wrong Week Day Input";
  }
}
