import 'package:spark_up/network/httpprotocol.dart';

class BasePost extends HttpData {
  late int userId;
  late String type;
  late String title;
  late String content;
  late String eventStartDate;
  late String eventEndDate;
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
        eventStartDate: "",
        eventEndDate: "",
        numberOfPeopleRequired: 0,
        location: "");
  }

  factory BasePost.initfromData(Map data) {
    return BasePost(
      userId: data["user_id"],
      type: data["type"],
      title: data["title"],
      content: data["content"],
      eventStartDate: data["event_start_date"],
      eventEndDate: data["event_end_date"],
      numberOfPeopleRequired: data["number_of_people_required"],
      location: data["location"],
      skills: data["skills"] ?? [],
      personalities: data["personalities"] ?? [],
      languages: data["languages"] ?? [],
      attributes: data["attributes"] ?? {},
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
    eventStartDate = DateTime.parse(eventStartDate).toUtc().toIso8601String();
    eventEndDate = DateTime.parse(eventEndDate).toUtc().toIso8601String();
    
    return {
      "user_id": userId,
      "type": type,
      "title": title,
      "content": content,
      "event_start_date": eventStartDate,
      "event_end_date": eventEndDate,
      "number_of_people_required": numberOfPeopleRequired,
      "location": location,
      "skills": skills,
      "personalities": personalities,
      "languages": languages,
      "attributes": attributes,
    };
  }
}
