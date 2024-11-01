import 'package:flutter/material.dart';
import "package:spark_up/const_variable.dart";
import "package:spark_up/data/base_post.dart";
import "package:spark_up/network/network.dart";
import "package:spark_up/network/path/post_path.dart";
import "package:toasty_box/toast_enums.dart";
import "package:toasty_box/toasty_box.dart";
import "package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_detailFill.dart";

class sparkPageEventTypeDecide extends StatefulWidget {
  const sparkPageEventTypeDecide({super.key});
  @override
  State<sparkPageEventTypeDecide> createState() => _sparkPageEventTypeDecideState();
}

class _sparkPageEventTypeDecideState extends State<sparkPageEventTypeDecide> {
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
    //_precacheImages();
  }

  // 預緩存所有圖片
  // Future<void> _precacheImages() async {
  //   for (var event in eventTypes) {
  //     await precacheImage(AssetImage(event["path"]!), context);
  //   }
  // }

  Widget eventTypeContainer(String eventName, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NextPage(selectedEventType: eventName),
          ),
        );
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // 添加預設背景色
          color: Colors.grey[200],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 使用 ClipRRect 來保持圓角
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                // 添加框架緩存
                cacheWidth: 140 * 2,
                cacheHeight: 140 * 2,
              ),
            ),
            // 添加漸層遮罩讓文字更容易閱讀
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  eventName,
                  style: TextStyle(
                    fontFamily: 'IowanOldStyle',
                    fontSize: eventName.length >= 8 ? 18 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    // 添加文字陰影增加可讀性
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1, 1),
                      ),
                    ],
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
                            "Please Select your Event Type",
                            style: TextStyle(
                              fontFamily: 'IowanOldStyle',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "that you want to SparkUp!",
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
                  ],
                )),
              ),
            ],
            ),
          ),
        ),
      ],
      ),
    );
  }
}