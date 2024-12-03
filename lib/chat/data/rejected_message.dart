class RejectedMessage {
  final int postId;
  final String postTitle;
  final String hostNickName;
  final String message;

  const RejectedMessage(
      {required this.postId,
      required this.postTitle,
      required this.hostNickName,
      required this.message});

  factory RejectedMessage.initfromData(Map data) {
    return RejectedMessage(
        postId: data["post_id"],
        postTitle: data["post_title"],
        hostNickName: data["host_nickname"],
        message: data["message"]);
  }
}
