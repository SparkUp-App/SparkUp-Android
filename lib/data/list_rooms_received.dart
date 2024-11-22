class ChatListReceived {
  late int postId;
  late String postName;
  late int unreadCount;
  late LatestMessage? latestMessage;

  ChatListReceived({
    required this.postId,
    required this.postName,
    required this.unreadCount,
    required this.latestMessage,
  });

  factory ChatListReceived.initfromData(Map data) {
    return ChatListReceived(
        postId: data["post_id"],
        postName: data["name"],
        unreadCount: data["unread_count"],
        latestMessage: data["latest_message"] == null
            ? null
            : LatestMessage.initfromData(data["latest_message"]));
  }
}

class LatestMessage {
  late int id;
  late int senderId;
  late String senderName;
  late String content;
  late DateTime createTime;

  LatestMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.createTime,
  });

  factory LatestMessage.initfromData(Map data) {
    return LatestMessage(
        id: data["id"],
        senderId: data["sender_id"],
        senderName: data["sender_name"],
        content: data["content"],
        createTime: DateTime.parse(data["created_at"]).toLocal());
  }
}
