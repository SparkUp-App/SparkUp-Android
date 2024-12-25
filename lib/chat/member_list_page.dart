import 'package:flutter/material.dart';
import 'package:spark_up/chat/data/room_users.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/common_widget/user_head.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/chat_path.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key, required this.postId});

  final int postId;

  @override
  State<MemberListPage> createState() => _MemeberListPageState();
}

class _MemeberListPageState extends State<MemberListPage> {
  bool isLoading = false;
  int totalUsers = 0;
  List<RoomUsers> userList = [];

  @override
  void initState() {
    super.initState();
    getUserList(context);
  }

  Future getUserList(BuildContext context) async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.get,
        path: ChatPath.roomUsers,
        pathMid: ["${widget.postId}"]);

    if (context.mounted) {
      if (response["status"] == "success") {
        userList = (response["data"]["users"] as List<dynamic>)
            .map((element) => RoomUsers.initfromData(element))
            .toList();
        totalUsers = response["data"]["total_users"];
      } else {
        showDialog(
            context: context,
            builder: (context) => const SystemMessage(
                content: "Something Went Wrong\n Pleas Try Again Later"));
      }
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leadingWidth: 50.0,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 8.0),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFFF77D43),
              size: 35.0,
            ),
          ),
          titleSpacing: 0.0,
          title: const Text(
            "Members",
            style: TextStyle(
                color: Color(0xFFF77D43),
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.white,
        body: isLoading && totalUsers == 0
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black26,
                  strokeWidth: 2.0,
                ),
              )
            : RefreshIndicator(
                backgroundColor: Colors.white,
                color: const Color(0xFFF77D43),
                onRefresh: () async {
                  await getUserList(context);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    for (var user in userList) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 3.0),
                        child: userCard(user: user, context: context),
                      ),
                    ]
                  ],
                ),
              ));
  }
}

Widget userCard({required RoomUsers user, required BuildContext context}) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        UserHead(userId: user.userId, level: user.level, size: 70.0),
        const SizedBox(
          width: 5.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.isHost)
              const Text(
                "Host",
                style: TextStyle(color: Color(0xFF7F7E7E), fontSize: 10.0),
              ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                user.nickname,
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Text(
              "${user.joinedAt.month}/${user.joinedAt.day} Joined",
              style: const TextStyle(color: Color(0xFF7F7E7E), fontSize: 12.0),
            )
          ],
        )
      ],
    ),
  );
}
