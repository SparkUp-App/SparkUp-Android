class ApplyMessage {
  final int postId;
  final String postTitle;
  final String userNickName;
  final String message;

  const ApplyMessage(
      {required this.postId,
      required this.postTitle,
      required this.userNickName,
      required this.message});

  factory ApplyMessage.initfromData(Map data) {
    return ApplyMessage(
        postId: data["post_id"],
        postTitle: data["post_title"],
        userNickName: data["user_nickname"],
        message: data["message"]);
  }
}
