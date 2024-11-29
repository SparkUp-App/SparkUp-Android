import "package:flutter/material.dart";
import "package:spark_up/data/profile.dart";
import "package:spark_up/screen/home_page_sub_screen/event_detail_page.dart";
import "package:spark_up/screen/home_page_sub_screen/profile_screen/participated_page.dart";
import "package:spark_up/screen/home_page_sub_screen/profile_screen/profile_show_page.dart";
import "package:spark_up/screen/home_page_sub_screen/profile_screen/rating_page.dart";
import "package:spark_up/screen/initial_profile_create/initial_profileData_detail.dart";
import "package:spark_up/screen/login_page.dart";
import "package:spark_up/screen/logout_page.dart";
import "package:spark_up/screen/register_page.dart";
import "package:spark_up/screen/home_page.dart";
import "package:spark_up/screen/initial_profile_create/initial_profileData_basicInfo.dart";
import "package:spark_up/screen/initial_profile_create/initial_profileData_eventType.dart";
import "package:spark_up/screen/home_page_sub_screen/profile_screen/edit_profile_page.dart";
import "package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_decide.dart";
import "package:spark_up/screen/home_page_sub_screen/profile_screen/level_show_page.dart";

class RouteMap {
  //Regist Path for page
  static const loginPage = "/loginPage";
  static const registerPage = "/registerPage";
  static const homePage = "/homePage";
  static const initialProfileDataPage = "/initialProfileDataPage";
  static const eventTypeProfilePage = "/eventTypeProfilePage";
  static const detailProfilePage = "/detailProfilePage";
  static const eventDetailePage = "/eventDetailPage";
  static const editProfile = "/profile_page";
  static const sparkUpEventTypeSelect = "/sparkPageEventTypeDecide";
  static const logoutPage = "/logoutPage";
  static const participatedPage = "/participatedPage";
  static const ratingPage = "/ratingPage";
  static const profileShowPage = "/profileShowPage";
  static const levelPage = "/levelShowPage";
  //Bind page to Path
  static Map<String, WidgetBuilder> routes = {
    loginPage: (context) => const LoginPage(),
    registerPage: (context) => const RegisterPage(),
    homePage: (context) => const HomePage(),
    initialProfileDataPage: (context) =>
        const BasicProfilePage(), //註冊完轉到initial個人資訊的頁面
    detailProfilePage: (context) => const DetailedProfilePage(),
    eventTypeProfilePage: (context) => const EventTypeProfilePage(),
    eventDetailePage: (context) {
      int postId = ModalRoute.of(context)!.settings.arguments as int;
      return EventDetailPage(postId: postId);
    },
    sparkUpEventTypeSelect: (context) => const sparkPageEventTypeDecide(),
    editProfile: (context) {
      Profile profile = ModalRoute.of(context)!.settings.arguments as Profile;
      return EditProfilePage(profile: profile);
    },
    logoutPage: (context) => const LogoutPage(),
    participatedPage: (context) {
      int userId = ModalRoute.of(context)!.settings.arguments as int;
      return ParticipatedPage(userId: userId);
    },
    ratingPage: (context) {
      int userId = ModalRoute.of(context)!.settings.arguments as int;
      return RatingPage(userId: userId);
    },
    profileShowPage: (context) {
      int userId;
      bool editable;
      (userId, editable) =
          ModalRoute.of(context)!.settings.arguments as (int, bool);
      return ProfileShowPage(userId: userId, editable: editable);
    },
    levelPage: (context) => const levelShowPage(),
  };
}
