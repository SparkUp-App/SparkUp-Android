class ChatMessage {
  final int id;
  final int postId;
  final int senderId;
  final String senderName;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.postId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.initfromData(Map<String, dynamic> data) {
    return ChatMessage(
      id: data['id'],
      postId: data['post_id'],
      senderId: data['sender_id'],
      senderName: data['sender_name'] as String,
      content: data['content'],
      createdAt: DateTime.parse(data['created_at']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'sender_id': senderId,
      'sender_name': senderName,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
