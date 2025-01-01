import 'package:flutter/material.dart';
import 'package:spark_up/chat/chat_room_manager.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/profile.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/profile_path.dart';
import "package:spark_up/route.dart";
import 'package:spark_up/secure_storage.dart';
import 'package:spark_up/socket_service.dart';

class EventTypeProfilePage extends StatefulWidget {
  const EventTypeProfilePage({super.key});

  @override
  State<EventTypeProfilePage> createState() => _EventTypeProfilePageState();
}

class _EventTypeProfilePageState extends State<EventTypeProfilePage> {
  bool selectOneAlert = false;

  bool isLoading = false;
  final List<Map<String, String>> eventTypes = [
    {"name": "Competition", "path": 'assets/event/competition.jpg'},
    {"name": "Roommate", "path": 'assets/event/roommates.jpg'},
    {"name": "Sport", "path": 'assets/event/sports.jpg'},
    {"name": "Study", "path": 'assets/event/study.jpg'},
    {"name": "Social", "path": 'assets/event/social.jpg'},
    {"name": "Travel", "path": 'assets/event/travel.jpg'},
    {"name": "Meal", "path": 'assets/event/meal.jpg'},
    {"name": "Speech", "path": 'assets/event/speech.jpg'},
    {"name": "Parade", "path": 'assets/event/parade.jpg'},
    {"name": "Exhibition", "path": 'assets/event/exhibition.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _precacheImages();
  }

  // 預緩存所有圖片
  Future<void> _precacheImages() async {
    for (var event in eventTypes) {
      await precacheImage(AssetImage(event["path"]!), context);
    }
  }

  Widget eventTypeContainer(String eventName, String imagePath) {
    bool isSelected = Profile.manager.interestTypes.contains(eventName);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            Profile.manager.interestTypes.remove(eventName);
          } else {
            selectOneAlert = false;
            Profile.manager.interestTypes.add(eventName);
          }
        });
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200], // 添加預設背景色
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                cacheWidth: 140 * 2,
                cacheHeight: 140 * 2,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected
                    ? Colors.white.withOpacity(0.8)
                    : Colors.black.withOpacity(0.3),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Color(0xFFF16743),
                size: 80,
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  eventName,
                  style: TextStyle(
                    fontFamily: 'IowanOldStyle',
                    color: isSelected ? const Color(0xFFF16743) : Colors.white,
                    fontSize: eventName.length >= 8 ? 18 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF16743), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: Stack(children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            //會自動偵測，避免超過看的到的地方
            child: Stack(children: [
              SingleChildScrollView(
                //一次load好比ListView慢load好
                child: SizedBox(
                    child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose the type you are interested in",
                            style: TextStyle(
                              fontFamily: 'IowanOldStyle',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "(Select one or more topics)",
                            style: TextStyle(
                              fontFamily: 'IowanOldStyle',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          eventTypeContainer(
                              "Competition", 'assets/event/competition.jpg'),
                          const SizedBox(height: 20),
                          eventTypeContainer(
                              "Roommate", 'assets/event/roommates.jpg'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          eventTypeContainer(
                              "Sport", 'assets/event/sports.jpg'),
                          const SizedBox(height: 20),
                          eventTypeContainer("Study", 'assets/event/study.jpg'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          eventTypeContainer(
                              "Social", 'assets/event/social.jpg'),
                          const SizedBox(height: 20),
                          eventTypeContainer(
                              "Travel", 'assets/event/travel.jpg'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          eventTypeContainer("Meal", 'assets/event/meal.jpg'),
                          const SizedBox(height: 20),
                          eventTypeContainer(
                              "Speech", 'assets/event/speech.jpg'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          eventTypeContainer(
                              "Parade", 'assets/event/parade.jpg'),
                          const SizedBox(height: 20),
                          eventTypeContainer(
                              "Exhibition", 'assets/event/exhibition.jpg'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    ),
                  ],
                )),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.1, // 設置背景的高度
                child: Container(
                  color: Colors.white.withOpacity(0.95), // 淺白色背景
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (selectOneAlert)
                          const Center(
                            child: Text(
                              "*At least select one type",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: "IowanOldStyle"),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 47,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, RouteMap.detailProfilePage),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF16743),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                    fontFamily: 'IowanOldStyle',
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              height: 47,
                              child: ElevatedButton(
                                onPressed: () => _navigateToNextProfile(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF16743),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Finish!',
                                  style: TextStyle(
                                    fontFamily: 'IowanOldStyle',
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ]),
          ),
        ),
        if (isLoading) ...[
          Opacity(
            opacity: 0.8,
            child: Container(
              color: Colors.black,
            ),
          ),
          const Center(child: CircularProgressIndicator(
            color: Color(0xFFF16743),
          ))
        ]
      ]),
    );
  }

  void _navigateToNextProfile() async {
    // Select at least one type judge
    if (Profile.manager.interestTypes.isEmpty) {
      setState(() {
        selectOneAlert = true;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    dynamic response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: ProfilePath.update,
        pathMid: ["${Network.manager.userId}"],
        data: Profile.manager.toMap);

    setState(() {
      isLoading = false;
    });

    if (response["status"] == "success" && context.mounted) {
      SecureStorage.store(StoreKey.noProfile, "No");
      SocketService.manager.initSocket(
          userId: Network.manager.userId!,
          onMessage: ChatRoomManager.manager.socketMessageCallback,
          onApprovedMessage: ChatRoomManager.manager.socketApproveCallback,
          onRejectedMessage: ChatRoomManager.manager.socketRejectedCallback,
          onApplyMessage: ChatRoomManager.manager.socketApplyCallback);
      ChatRoomManager.manager.getData();
      Navigator.pushReplacementNamed(context, RouteMap.tutorialPage,
          arguments: false);
    } else {
      showDialog(
          context: context,
          builder: (context) => SystemMessage(
              content:
                  "Profile Update Failed (Error: ${response["data"]["message"]})"));
    }
  }
}
