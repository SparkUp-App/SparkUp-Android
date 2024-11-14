class ApplicantListReceived {
  late int postId;
  late String postTitle;
  late int numberOfPeopleRequired;
  late List<ApplicantUser> applicants;

  ApplicantListReceived({
    required this.postId,
    required this.postTitle,
    required this.numberOfPeopleRequired,
    required this.applicants,
  });

  factory ApplicantListReceived.initfromData(Map data) {
    return ApplicantListReceived(
        postId: data["post_id"],
        postTitle: data["post_title"],
        numberOfPeopleRequired: data["number_of_people_required"],
        applicants: (data["applicants"] as List<dynamic>)
            .map((element) => ApplicantUser.initfromData(element))
            .toList());
  }
}

class ApplicantUser {
  late int userId;
  late String nickname;
  late DateTime appliedTime;
  late Map<String, dynamic> attributes;

  ApplicantUser({
    required this.userId,
    required this.nickname,
    required this.appliedTime,
    required this.attributes,
  });

  factory ApplicantUser.initfromData(Map data) {
    return ApplicantUser(
        userId: data["user_id"],
        nickname: data["nickname"],
        appliedTime: DateTime.parse(data["applied_time"]).toLocal(),
        attributes: data["attributes"]);
  }
}
