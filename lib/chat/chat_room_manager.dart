import 'package:flutter/material.dart';
import 'package:spark_up/background_notification_service.dart';
import 'package:spark_up/chat/data/apply_message.dart';
import 'package:spark_up/chat/data/approved_message.dart';
import 'package:spark_up/chat/data/chat_message.dart';
import 'package:spark_up/chat/data/rejected_message.dart';
import 'package:spark_up/data/list_rooms_received.dart';
import 'package:spark_up/main.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/chat_path.dart';
import 'package:spark_up/notificatoin_manager.dart';

class ChatRoomManager {
  static ChatRoomManager manager = ChatRoomManager();
  late bool hasData;
  late ValueNotifier<bool> isLoading;
  late bool error;
  late int roomCount;
  late ValueNotifier<List<ChatListReceived>> roomList;
  late int page, perPage, pages;
  late bool noMoreData;
  late int? currentPostId;
  late ValueNotifier<ChatMessage?> updateMessage;

  ChatRoomManager() {
    hasData = false;
    isLoading = ValueNotifier(false);
    error = false;
    roomCount = 0;
    roomList = ValueNotifier([]);
    page = 1;
    perPage = 20;
    pages = 0;
    noMoreData = false;
    currentPostId = null;
    updateMessage = ValueNotifier(null);
  }

  Future<void> getData() async {
    if (isLoading.value || noMoreData || error) return;
    isLoading.value = true;

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: ChatPath.rooms,
        data: {"page": page, "per_page": perPage},
        pathMid: ["${Network.manager.userId}"]);

    if (response["status"] == "success") {
      roomList.value = [
        ...roomList.value,
        ...((response["data"]["rooms"] as List<dynamic>)
            .map((element) => ChatListReceived.initfromData(element))
            .toList())
      ];

      roomCount = roomList.value.length;
      page = response["data"]["page"] + 1;
      pages = response["data"]["pages"];
      noMoreData = page > pages;
    } else {
      error = true;
    }

    isLoading.value = false;
    return;
  }

  Future<void> refresh() async {
    if (isLoading.value) return;
    await clear();
    await getData();

    return;
  }

  Future<void> clear() async {
    hasData = false;
    isLoading.value = false;
    error = false;
    roomCount = 0;
    roomList.value = [];
    page = 1;
    perPage = 20;
    pages = 0;
    noMoreData = false;

    return;
  }

  void socketMessageCallback(ChatMessage message) {
    // For Update Current Room Message
    if (message.postId == currentPostId) {
      updateMessage.value = message;
    }

    // For Update Chat Room List
    for (int i = 0; i < roomCount; i++) {
      if (roomList.value[i].postId == message.postId) {
        ChatListReceived updateChatRoom;
        updateChatRoom = roomList.value[i];
        LatestMessage updateLatestMessage = LatestMessage(
            id: message.id,
            senderId: message.senderId,
            senderName: message.senderName,
            content: message.content,
            createTime: message.createdAt);
        updateChatRoom.latestMessage = updateLatestMessage;
        if (message.senderId != Network.manager.userId &&
            currentPostId != message.postId) {
          updateChatRoom.unreadCount++;

          BuildContext? context = MyApp.navigatorKey.currentContext;

          if (WidgetsBinding.instance.lifecycleState ==
              AppLifecycleState.resumed && NotificationManager.foregroundNewMessage) {
            // App Foreground Notification

            // Display SnackBar in app
            if (context != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                content: Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "New Message - ${message.postTitle}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${message.senderName}: ${message.content}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                duration: const Duration(seconds: 3),
              ));
            }
          } 
        }

        if (WidgetsBinding.instance.lifecycleState ==
              AppLifecycleState.paused && NotificationManager.backgroundNewMessage && message.senderId != Network.manager.userId) {
            // App Background Notification
            BackgroundNotificationService.manager
                .handleIncomingMessage(message);
          }

        roomList.value.removeAt(i);
        roomList.value = [updateChatRoom, ...roomList.value];
        break;
      }
    }
  }

  void socketApproveCallback(ApprovedMessage message) {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed && NotificationManager.foregroundApproveMessage) {
      // Foreground Notification
      // Display SnackBar in app
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Approved Message",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${message.hostNickName} arrpoved your apply in ${message.postTitle}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          duration: const Duration(seconds: 3),
        ));
      }
    } else if (WidgetsBinding.instance.lifecycleState ==
        AppLifecycleState.paused && NotificationManager.backgroundApproveMessage) {
      // Background Notification
      BackgroundNotificationService.manager
          .handleIncomingApprovedMessage(message);
    }
  }

  void socketRejectedCallback(RejectedMessage message) {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed && NotificationManager.foregroundRejectMessage) {
      // Foreground Notification

      // Display SnackBar in app
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Rejected Message",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${message.hostNickName} rejected your apply in ${message.postTitle}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          duration: const Duration(seconds: 3),
        ));
      }
    } else if (WidgetsBinding.instance.lifecycleState ==
        AppLifecycleState.paused && NotificationManager.backgroundRejectMessage) {
      // Background Notification
      BackgroundNotificationService.manager
          .handleIncomingRejectedMessage(message);
    }
  }

  void socketApplyCallback(ApplyMessage message) {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed && NotificationManager.foregroundApplyMessage) {
      // Foreground Notification

      // Display SnackBar in app
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "New Apply Message",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  message.message,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          duration: const Duration(seconds: 3),
        ));
      }
    } else if (WidgetsBinding.instance.lifecycleState ==
        AppLifecycleState.paused && NotificationManager.backgroundApplyMessage) {
      // Background Notification
      BackgroundNotificationService.manager
          .handleIncomingApplymessage(message);
    }
  }
}
