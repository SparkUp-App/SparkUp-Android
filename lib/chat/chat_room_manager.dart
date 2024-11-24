import 'package:flutter/material.dart';
import 'package:spark_up/data/list_rooms_received.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/chat_path.dart';
import 'package:spark_up/socket_service.dart';

class ChatRoomManager {
  static ChatRoomManager manager = ChatRoomManager();
  late bool hasData;
  late ValueNotifier<bool> isLoading;
  late bool error;
  late int roomCount;
  late ValueNotifier<List<ChatListReceived>> roomList;
  late int page, perPage, pages;
  late bool noMoreData;

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
        if (message.senderId != Network.manager.userId) {
          updateChatRoom.unreadCount++;
        }

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
