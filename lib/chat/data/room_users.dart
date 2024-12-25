class RoomUsers {
  late int userId;
  late String nickname;
  late double rating;
  late DateTime joinedAt;
  late bool isHost;
  late int level;

  RoomUsers({
    required this.userId,
    required this.nickname,
    required this.rating,
    required this.joinedAt,
    required this.isHost,
    required this.level,
  });

  factory RoomUsers.initfromData(Map data) {
    return RoomUsers(
        userId: data["user_id"],
        nickname: data["nickname"],
        rating: data["rating"],
        joinedAt: DateTime.parse(data["joined_at"]).toLocal(),
        isHost: data["is_host"],
        level: data["level"]);
  }
}
