import 'package:flutter/material.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/route.dart';

Widget userHead(
    {required int userId, required int level, required double size}) {
  return UserHead(userId: userId, level: level, size: size);
}

class UserHead extends StatelessWidget {
  const UserHead(
      {super.key,
      required this.userId,
      required this.level,
      required this.size,
      this.canRouteProfile = false});
  final int userId;
  final int level;
  final double size;
  final bool canRouteProfile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (canRouteProfile) {
          Navigator.pushNamed(context, RouteMap.profileShowPage,
              arguments: (userId, Network.manager.userId == userId, false));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            switch (level) {
              0 => 'assets/member/Nebulas.png',
              1 => 'assets/member/Proto Star.png',
              2 => 'asssets/member/Main Sequence.png',
              3 => 'assets/member/Red Giant.png',
              4 => 'assets/member/Supernova.png',
              int() => 'assets/member/Nebulas.png',
            },
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
