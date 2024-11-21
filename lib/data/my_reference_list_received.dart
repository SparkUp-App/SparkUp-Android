class MyReferenceListReceived {
  late MyReferenceEvent event;
  late List<MyReference> referenceList;

  MyReferenceListReceived({
    required this.event,
    required this.referenceList,
  });

  factory MyReferenceListReceived.initfromData(Map data) {
    return MyReferenceListReceived(
        event: MyReferenceEvent.initformData(data["event"]),
        referenceList: (data["references"] as List<dynamic>)
            .map((element) => MyReference.initfromData(element))
            .toList());
  }
}

class MyReferenceEvent {
  late int postId;
  late String postTitle;
  late String type;
  late DateTime eventStartDate;
  late DateTime eventEndDate;
  late String location;
  late double averageRating;
  late int ratingCount;

  MyReferenceEvent({
    required this.postId,
    required this.postTitle,
    required this.type,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.location,
    required this.averageRating,
    required this.ratingCount,
  });

  factory MyReferenceEvent.initformData(Map data) {
    return MyReferenceEvent(
      postId: data["post_id"],
      postTitle: data["title"],
      type: data["type"],
      eventStartDate: DateTime.parse(data["event_start_date"]).toLocal(),
      eventEndDate: DateTime.parse(data["event_end_date"]).toLocal(),
      location: data["location"],
      averageRating: data["average_rating"],
      ratingCount: data["rating_count"],
    );
  }
}

class MyReference {
  late int userId;
  late String nickname;
  late int rating;
  late String content;
  late bool isHost;

  MyReference({
    required this.userId,
    required this.nickname,
    required this.rating,
    required this.content,
    required this.isHost,
  });

  factory MyReference.initfromData(Map data) {
    return MyReference(
      userId: data["from_user_id"],
      nickname: data["from_user_nickname"],
      rating: data["rating"],
      content: data["content"],
      isHost: data["is_host"],
    );
  }
}
