class ApprovedMessage {
  final int postId;
  final String postTitle;
  final String hostNickName;
  final String message;

  const ApprovedMessage(
      {required this.postId,
      required this.postTitle,
      required this.hostNickName,
      required this.message});

  factory ApprovedMessage.initfromData(Map data) {
    return ApprovedMessage(
        postId: data["post_id"],
        postTitle: data["post_title"],
        hostNickName: data["host_nickname"],
        message: data["message"]);
  }
}
