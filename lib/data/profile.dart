import 'package:spark_up/const_variable.dart';
import 'package:spark_up/network/httpprotocol.dart';

class Profile extends HttpData {
  static late Profile manager;

  late String phone;
  late String nickname;
  late String dob;
  late Gender gneder;
  late String bio;
  late String currentLocation;
  late String hoemTown;
  late String college;
  late String jobTitle;
  late String educationLevel;
  late String mbti;
  late String constellation;
  late String bloodType;
  late String religion;
  late String sexuality;
  late String ethnicity;
  late String diet;
  late Smoke smoke;
  late Drinking drinking;
  late Marijuana marijuana;
  late Drugs drugs;
  List<String> skills;
  List<String> personalities;
  List<String> languages;
  List<String> interestTypes;

  Profile({
    required this.phone,
    required this.nickname,
    required this.dob,
    required this.gneder,
    this.bio = "",
    this.currentLocation = "",
    this.hoemTown = "",
    this.college = "",
    this.jobTitle = "",
    this.educationLevel = "Prefer not to say",
    this.mbti = "Prefer not to say",
    this.constellation = "Prefer not to say",
    this.bloodType = "Prefer not to say",
    this.religion = "Prefer not to say",
    this.sexuality = "Prefer not to say",
    this.ethnicity = "Prefer not to say",
    this.diet = "Prefer not to say",
    this.smoke = Smoke.notToSay,
    this.drinking = Drinking.notToSay,
    this.marijuana = Marijuana.notToSay,
    this.drugs = Drugs.notToSay,
    List<String>? skills,
    List<String>? personalities,
    List<String>? languages,
    List<String>? interestTypes,
  })  : skills = skills ?? [],
        personalities = personalities ?? [],
        languages = languages ?? [],
        interestTypes = interestTypes ?? [];

  factory Profile.initfromData(Map data) {
    return Profile(
      phone: data["phone"] ?? "",
      nickname: data["nickname"] ?? "",
      dob: data["dob"] ?? "",
      gneder: data["gender"].runtimeType == String
          ? Gender.fromString(data["gender"])
          : Gender.fromint(data["gender"]),
      bio: data["bio"] ?? "",
      currentLocation: data["current_location"] ?? "",
      hoemTown: data["hometown"] ?? "",
      college: data["college"] ?? "",
      jobTitle: data["job_title"] ?? "",
      educationLevel: data["education_level"] ?? "Prefer not to say",
      mbti: data["mbti"] ?? "Prefer not to say",
      constellation: data["constellation"] ?? "Prefer not to say",
      bloodType: data["blood_type"] ?? "Prefer not to say",
      religion: data["religion"] ?? "Prefer not to say",
      sexuality: data["sexuality"] ?? "Prefer not to say",
      ethnicity: data["ethnicity"] ?? "Prefer not to say",
      diet: data["diet"] ?? "Prefer not to say",
      smoke: data["smoke"].runtimeType == String
          ? Smoke.fromString(data["smoke"])
          : Smoke.fromint(data["smoke"]),
      drinking: data["drinking"].runtimeType == String
          ? Drinking.fromString(data["drinking"])
          : Drinking.fromint(data["smoke"]),
      marijuana: data["marijuana"].runtimeType == String
          ? Marijuana.fromString(data["marijuana"])
          : Marijuana.fromint(data["marijuana"]),
      drugs: data["drugs"].runtimeType == String
          ? Drugs.fromString(data["drugs"])
          : Drugs.fromint(data["drugs"]),
      skills: data["skills"].runtimeType == Null? []:List<String>.from(data["skills"]),
      personalities: data["personalities"].runtimeType == Null? []:List<String>.from(data["personalities"]),
      languages: data["languages"].runtimeType == Null? []:List<String>.from(data["languages"]),
      interestTypes: data["interest_types"].runtimeType == Null? []: List<String>.from(data["interest_types"]),
    );
  }

  Map<String, dynamic> get toProfile {
    return {
      "phone": phone,
      "nickname": nickname,
      "dob": dob,
      "gender": gneder.label,
      "bio": bio,
      "current_location": currentLocation,
      "hometown": hoemTown,
      "college": college,
      "job_title": jobTitle,
      "education_level": educationLevel,
      "mbti": mbti,
      "constellation": constellation,
      "blood_type": bloodType,
      "religion": religion,
      "sexuality": sexuality,
      "ethnicity": ethnicity,
      "diet": diet,
      "smoke": smoke.label,
      "drinking": drinking.label,
      "marijuana": marijuana.label,
      "drugs": drugs.label,
      "skills": skills,
      "personalities": personalities,
      "languages": languages,
      "interest_types": interestTypes,
    };
  }

  @override
  Map<String, dynamic> get toMap {
    return {
      "phone": phone,
      "nickname": nickname,
      "dob": dob,
      "gender": gneder.value,
      "bio": bio,
      "current_location": currentLocation,
      "hometown": hoemTown,
      "college": college,
      "job_title": jobTitle,
      "education_level": educationLevel,
      "mbti": mbti,
      "constellation": constellation,
      "blood_type": bloodType,
      "religion": religion,
      "sexuality": sexuality,
      "ethnicity": ethnicity,
      "diet": diet,
      "smoke": smoke.value,
      "drinking": drinking.value,
      "marijuana": marijuana.value,
      "drugs": drugs.value,
      "skills": skills,
      "personalities": personalities,
      "languages": languages,
      "interest_types": interestTypes,
    };
  }
}
