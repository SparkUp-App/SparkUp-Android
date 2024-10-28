class PostView{
  late int postId;
  late String nickname;
  late String type;
  late String title;
  late String content;
  late DateTime eventStartDate;
  late DateTime eventEndDate;
  late int numberOfPeopleRequired;
  late String location;
  late List<String> skills;
  late List<String> personalities;
  late List<String> languages;
  late Map<String, dynamic> attributes;
  late int likes;
  late bool liked;
  late int bookmarks;
  late bool bookmarked;
  late int comments;
  late int? applicants;
  late int? applicationStatus;

  PostView({
    required this.postId,
    required this.nickname,
    required this.type,
    required this.title,
    required this.content,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.numberOfPeopleRequired,
    required this.location,
    required this.skills,
    required this.personalities,
    required this.languages,
    required this.attributes,
    required this.likes,
    required this.liked,
    required this.bookmarks,
    required this.bookmarked,
    required this.comments,
    required this.applicants,
    required this.applicationStatus,
  });

  factory PostView.initfromData(Map<String, dynamic> data) {
    return PostView(
      postId: data['id'] as int,
      nickname: data['nickname'] as String,
      type: data['type'] as String,
      title: data['title'] as String,
      content: data['content'] as String,
      eventStartDate: DateTime.parse(data['event_start_date'] as String).toLocal(),
      eventEndDate: DateTime.parse(data['event_end_date'] as String).toLocal(),
      numberOfPeopleRequired: data['number_of_people_required'] as int,
      location: data['location'] as String,
      skills: List<String>.from(data['skills']),
      personalities: List<String>.from(data['personalities']),
      languages: List<String>.from(data['languages']),
      attributes: data["attributes"],
      likes: data['likes'] as int,
      liked: data['liked'] as bool,
      bookmarks: data['bookmarks'] as int,
      bookmarked: data['bookmarked'] as bool,
      comments: data['comments'] as int,
      applicants: data['applicants'] as int,
      applicationStatus: data['application_status'],
    );
  }
}