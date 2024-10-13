class ListReceivePost {
  late int postId;
  late String posterNickname;
  late String type;
  late String title;
  late DateTime eventStartDate;
  late DateTime eventEndDate;
  late int numberOfPeopleRequired;
  late int likes;
  late bool liked;
  late int bookmarks;
  late bool bookmarked;
  late int comments;
  late int applicants;

  ListReceivePost({
    required this.postId,
    required this.posterNickname,
    required this.type,
    required this.title,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.numberOfPeopleRequired,
    required this.likes,
    required this.liked,
    required this.bookmarks,
    required this.bookmarked,
    required this.comments,
    required this.applicants,
  });

  factory ListReceivePost.initfromData(Map data) {
    return ListReceivePost(
        postId: data["id"],
        posterNickname: data["nickname"],
        type: data["type"],
        title: data["title"],
        eventStartDate: DateTime.parse(data["event_start_date"]).toLocal(),
        eventEndDate: DateTime.parse(data["event_end_date"]).toLocal(),
        numberOfPeopleRequired: data["number_of_people_required"],
        likes: data["likes"],
        liked: data["liked"],
        bookmarks: data["bookmarks"],
        bookmarked: data["bookmarked"],
        comments: data["comments"],
        applicants: data["applicants"]);
  }
}
