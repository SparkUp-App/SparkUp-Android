import 'package:spark_up/network/httpprotocol.dart';

class Profile extends HttpData {
  static late Profile manager;

  late String phone;
  late String nickname;
  late String dob;
  late int gneder;
  String? bio;
  String? currentLocation;
  String? hoemTown;
  String? college;
  String? jobTitle;
  String? educationLevel;
  String? mbti;
  String? constellation;
  String? bloodType;
  String? religion;
  String? sexuality;
  String? ethnicity;
  String? diet;
  int? smoke;
  int? drinking;
  int? marijuana;
  int? drugs;
  List<String> skills;
  List<String> personalities;
  List<String> languages;
  List<String> interestTypes;


  Profile(
      {
      required this.phone,
      required this.nickname,
      required this.dob,
      required this.gneder,
      this.bio,
      this.currentLocation,
      this.hoemTown,
      this.college,
      this.jobTitle,
      this.educationLevel,
      this.mbti,
      this.constellation,
      this.bloodType,
      this.religion,
      this.sexuality,
      this.ethnicity,
      this.diet,
      this.smoke,
      this.drinking,
      this.marijuana,
      this.drugs,
      List<String>? skills,
      List<String>? personalities,
      List<String>? languages,
      List<String>? interestTypes,
      })
      : skills = skills ?? [],
        personalities = personalities ?? [],
        languages = languages ?? [],
        interestTypes = interestTypes ?? [];

    factory Profile.initfromData(Map data){
      return Profile(
        phone: data["phone"],
        nickname: data["nickname"], 
        dob: data["dob"],
        gneder: data["gender"],
        bio : data["bio"],
        currentLocation: data["current_location"],
        hoemTown: data["hometown"],
        college: data["college"],
        jobTitle: data["job_title"],
        educationLevel: data["education_level"],
        mbti: data["mbti"],
        constellation: data["constellation"],
        bloodType: data["blood_tpye"],
        religion: data["religion"],
        sexuality: data["sexuality"],
        ethnicity: data["ethnicity"],
        diet: data["diet"],
        smoke: data["smoke"],
        drinking: data["drinking"],
        marijuana: data["maijuana"],
        drugs: data["drugs"],
        skills: data["skills"],
        personalities: data["personalitites"],
        languages: data["languages"],
        interestTypes: data["interest_types"],
        );
    }

  @override
  Map<dynamic, dynamic> get toMap {
    return {
      "phone" : phone,
      "nickname" : nickname,
      "dob" : dob,
      "gender" : gneder,
      "bio" : bio,
      "current_location" : currentLocation,
      "hometown" : hoemTown,
      "college" : college,
      "job_title" : jobTitle,
      "education_level" : educationLevel,
      "mbti" : mbti,
      "constellation" : constellation,
      "blood_type" : bloodType,
      "religion" : religion,
      "sexuality" : sexuality,
      "ethnicity" : ethnicity,
      "diet" : diet,
      "smoke" : smoke,
      "drinking" : drinking,
      "marijuana" : marijuana,
      "drugs" : drugs,
      "skills" : skills,
      "personalities" : personalities,
      "languages" : languages,
      "interest_types" : interestTypes,
    };
  }
}
