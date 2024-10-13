import 'package:spark_up/network/httpprotocol.dart';

class BasePost extends HttpData {
  late int userId;
  late String type;
  late String title;
  late String content;
  late DateTime eventStartDate;
  late DateTime eventEndDate;
  late int numberOfPeopleRequired;
  late String location;
  List<String> skills = [];
  List<String> personalities = [];
  List<String> languages = [];
  Map<String, dynamic> attributes = {};

  int? postId;
  String? posterNickname;
  int? likes;
  bool? liked;
  int? bookmarks;
  bool? bookmarked;
  int? comments;
  int? applicants;

  BasePost({
    required this.userId,
    required this.type,
    required this.title,
    required this.content,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.numberOfPeopleRequired,
    required this.location,
    List<String>? skills,
    List<String>? personalities,
    List<String>? languages,
    Map<String, dynamic>? attributes,

    this.postId,
    this.posterNickname,
    this.likes,
    this.liked,
    this.bookmarks,
    this.bookmarked,
    this.comments,
    this.applicants
  })  : skills = skills ?? [],
        personalities = personalities ?? [],
        languages = languages ?? [],
        attributes = attributes ?? {};

  factory BasePost.initfromDefaule(int userId) {
    return BasePost(
        userId: userId,
        type: "",
        title: "",
        content: "",
        eventStartDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        eventEndDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        numberOfPeopleRequired: 0,
        location: "");
  }

  factory BasePost.initfromData(Map data) {
    return BasePost(
      userId: data["user_id"] ?? 0,
      type: data["type"],
      title: data["title"],
      content: data["content"],
      eventStartDate: DateTime.parse(data["event_start_date"]).toLocal(),
      eventEndDate: DateTime.parse(data["event_end_date"]).toLocal(),
      numberOfPeopleRequired: data["number_of_people_required"],
      location: data["location"],
      skills: List<String>.from(data["skills"]),
      personalities: List<String>.from(data["personalities"]),
      languages: List<String>.from(data["languages"]),
      attributes: data["attributes"].cast<String, dynamic>(),
      postId: data["id"],
      posterNickname: data["nickname"],
      likes: data["likes"],
      liked: data["liked"],
      comments: data["comments"],
      applicants: data["applicants"]
    );
  }

  @override
  Map<String, dynamic> get toMap {
    return {
      "user_id": userId,
      "type": type,
      "title": title,
      "content": content,
      "event_start_date": eventStartDate.toUtc().toIso8601String(),
      "event_end_date": eventEndDate.toUtc().toIso8601String(),
      "number_of_people_required": numberOfPeopleRequired,
      "location": location,
      "skills": skills,
      "personalities": personalities,
      "languages": languages,
      "attributes": attributes,
    };
  }
}
