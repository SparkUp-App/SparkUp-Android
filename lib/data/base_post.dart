import 'package:spark_up/network/httpprotocol.dart';

class BasePost extends HttpData {
  late int userId;
  late String type;
  late String title;
  late String content;
  late String eventStartDate;
  late String evenEndDate;
  late int numberOfPeopleRequired;
  late String location;
  List<String> skills = [];
  List<String> personalities = [];
  List<String> languages = [];
  Map<String, dynamic> attributes = {};

  BasePost({
    required this.userId,
    required this.type,
    required this.title,
    required this.content,
    required this.eventStartDate,
    required this.evenEndDate,
    required this.numberOfPeopleRequired,
    required this.location,
    List<String>? skills,
    List<String>? personalities,
    List<String>? languages,
    Map<String, dynamic>? attributes,
  })  : skills = skills ?? [],
        personalities = personalities ?? [],
        languages = languages ?? [],
        attributes = attributes ?? {};

  factory BasePost.initfromData(Map data) {
    return BasePost(
        userId: data["user_id"],
        type: data["type"],
        title: data["title"],
        content: data["content"],
        eventStartDate: data["event_start_date"],
        evenEndDate: data["event_end_data"],
        numberOfPeopleRequired: data["number_of_people_required"],
        location: data["location"],
        skills: data["skills"] ?? [],
        personalities: data["personalities"] ?? [],
        languages: data["languages"] ?? [],
        attributes: data["attributes"] ?? {},
        );
  }

  @override
  Map<String, dynamic> get toMap {
    return {
      "user_id": userId,
      "type": type,
      "title": title,
      "content": content,
      "event_start_date": eventStartDate,
      "event_end_date": evenEndDate,
      "number_of_people_requried": numberOfPeopleRequired,
      "location": location,
      "skills": skills,
      "personalities": personalities,
      "languages": languages,
      "attributes": attributes,
    };
  }
}
