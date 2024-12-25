class Comment {
  late int commentsId;
  late int postId;
  late int userId;
  late String content;
  late bool deleted;
  late DateTime createdDate;
  late DateTime lastUpdateDate;
  late int floor;
  late int likes;
  late String userNickName;
  late bool liked;
  late int level;

  Comment({
    required this.commentsId,
    required this.postId,
    required this.userId,
    required this.content,
    required this.deleted,
    required this.createdDate,
    required this.lastUpdateDate,
    required this.floor,
    required this.likes,
    required this.userNickName,
    required this.liked,
    required this.level,
  });

  factory Comment.initfromData(Map data) {
    return Comment(
      commentsId: data["id"],
      postId: data["post_id"],
      userId: data["user_id"],
      content: data["content"],
      deleted: data["deleted"],
      createdDate: DateTime.parse(data["comment_created_date"]).toLocal(),
      lastUpdateDate:
          DateTime.parse(data["comment_last_updated_date"]).toLocal(),
      floor: data["floor"],
      likes: data["likes"],
      userNickName: data["nickname"],
      liked: data["liked"],
      level: data["level"],
    );
  }
}
