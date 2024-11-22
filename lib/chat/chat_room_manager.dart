import 'package:flutter/material.dart';
import 'package:spark_up/data/list_rooms_received.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/chat_path.dart';
import 'package:spark_up/socket_service.dart';

class ChatRoomManager {
  static ChatRoomManager manager = ChatRoomManager();
  late ValueNotifier<bool> hasData;
  late ValueNotifier<bool> isLoading;
  late ValueNotifier<bool> error;
  late int roomCount;
  late ValueNotifier<List<ChatListReceived>> roomList;
  late int page, perPage, pages;
  late ValueNotifier<bool> noMoreData;

  ChatRoomManager() {
    hasData = ValueNotifier(false);
    isLoading = ValueNotifier(false);
    error = ValueNotifier(false);
    roomCount = 0;
    roomList = ValueNotifier([]);
    page = 1;
    perPage = 20;
    pages = 0;
    noMoreData = ValueNotifier(false);
  }

  Future<void> getData() async {
    if (isLoading.value || noMoreData.value || error.value) return;
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
      noMoreData.value = page > pages;
    } else {
      error.value = true;
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
    hasData.value = false;
    isLoading.value = false;
    error.value = false;
    roomCount = 0;
    roomList.value = [];
    page = 1;
    perPage = 20;
    pages = 0;
    noMoreData.value = false;

    return;
  }

  void socketMessageCallback(ChatMessage message) {
    for (int i = 0; i < roomCount; i++) {
      if (roomList.value[i].postId == message.postId) {
        ChatListReceived updateChatRoom;
        updateChatRoom = roomList.value[i];
        updateChatRoom.latestMessage.id = message.id;
        updateChatRoom.latestMessage.senderId = message.senderId;
        updateChatRoom.latestMessage.senderName = message.senderName;
        updateChatRoom.latestMessage.content = message.content;
        updateChatRoom.latestMessage.createTime = message.createdAt;
        updateChatRoom.unreadCount++;

        roomList.value.removeAt(i);
        roomList.value = [updateChatRoom, ...roomList.value];
        break;
      }
    }
  }

  void socketApproveCallback(ApprovedMessage message) {
    refresh();
  }

  void socketRejectedCallback(RejectedMessage message) {
    refresh();
  }
}
