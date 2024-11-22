class ReferenceListReceived {
  late int postId;
  late String postTitle;
  late String postType;
  late DateTime eventStartDate;
  late DateTime eventEndDate;
  late String location;
  late int userId;
  late String nickname;
  late String role;

  ReferenceListReceived(
      {required this.postId,
      required this.postTitle,
      required this.postType,
      required this.eventStartDate,
      required this.eventEndDate,
      required this.location,
      required this.userId,
      required this.nickname,
      required this.role});

  factory ReferenceListReceived.initfromData(Map data) {
    return ReferenceListReceived(
        postId: data["post_id"],
        postTitle: data["post_title"],
        postType: data["post_type"],
        eventStartDate: DateTime.parse(data["event_start_date"]).toLocal(),
        eventEndDate: DateTime.parse(data["event_end_date"]).toLocal(),
        location: data["location"],
        userId: data["user_id"],
        nickname: data["nickname"],
        role: data["role"]);
  }
}
