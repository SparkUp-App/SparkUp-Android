class ChatMessage {
  final int id;
  final int? postId;
  final String? postTitle;
  final int senderId;
  final String senderName;
  final String content;
  final DateTime createdAt;
  final List<int>? readUsers;

  ChatMessage({
    required this.id,
    this.postId,
    this.postTitle,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.createdAt,
    this.readUsers,
  });

  factory ChatMessage.initfromData(Map<String, dynamic> data) {
    return ChatMessage(
      id: data['id'],
      postId: data['post_id'],
      postTitle: data['post_title'],
      senderId: data['sender_id'],
      senderName: data['sender_name'] as String,
      content: data['content'],
      createdAt: DateTime.parse(data['created_at']).toLocal(),
      readUsers: data['read_users'] == null
          ? null
          : (data["read_users"] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toMap() {
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
