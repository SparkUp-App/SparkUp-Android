import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SparkIcon extends StatelessWidget {
  final SparkIcons icon;
  final double size;
  final Color? color;

  const SparkIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
          icon.path,
          width: size,
          height: size,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        );
  }
}

enum SparkIcons {
  back('assets/icons/back.svg'),
  comment('assets/icons/comment.svg'),
  heart('assets/icons/heart.svg'),
  alcohol('assets/icons/alcohol.svg'),
  blood('assets/icons/blood.svg'),
  bookmark('assets/icons/bookmark.svg'),
  bookmarkBorder("assets/icons/bookmark_border.svg"),
  calendar('assets/icons/calendar.svg'),
  car('assets/icons/car.svg'),
  circleUser('assets/icons/circle_user.svg'),
  city('assets/icons/city.svg'),
  eat('assets/icons/eat.svg'),
  education('assets/icons/education.svg'),
  email('assets/icons/email.svg'),
  flag('assets/icons/flag.svg'),
  gender('assets/icons/gender.svg'),
  globe('assets/icons/globe.svg'),
  home('assets/icons/home.svg'),
  homeBorder("assets/icons/home_border.svg"),
  hometown('assets/icons/hometown.svg'),
  language('assets/icons/language.svg'),
  location('assets/icons/location.svg'),
  message('assets/icons/message.svg'),
  messageBorder("assets/icons/message_border.svg"),
  password('assets/icons/password.svg'),
  peace('assets/icons/peace.svg'),
  person('assets/icons/person.svg'),
  phone('assets/icons/phone.svg'),
  plus('assets/icons/plus.svg'),
  religion('assets/icons/religion.svg'),
  school('assets/icons/school.svg'),
  setting('assets/icons/setting.svg'),
  sexuality('assets/icons/sexuality.svg'),
  skill('assets/icons/skill.svg'),
  smile('assets/icons/smile.svg'),
  smoking('assets/icons/smoking.svg'),
  star('assets/icons/star.svg'),
  user('assets/icons/user.svg'),
  userBorder("assets/icons/user_border.svg"),
  users('assets/icons/users.svg'),
  work('assets/icons/work.svg'),
  zodiacSign('assets/icons/zodiac_sign.svg');

  final String path;
  const SparkIcons(this.path);

  String get assetPath => path;
}
