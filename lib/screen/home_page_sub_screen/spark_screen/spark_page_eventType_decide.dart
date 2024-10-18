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

Widget eventTypeContainer(String eventName, String imagePath) {

    return GestureDetector(
       onTap: () {
        // 使用 Navigator 導航到下一頁，並傳遞選擇的事件類型
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NextPage(selectedEventType: eventName),
          ),
        );
      },
      child: Container(
        //包圖片用
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath), //圖片確定是正方形，直接cover
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          //在當前的Container中，再疊一層用來顯示選擇與否的顯示法
          alignment: Alignment.center, //對其當前Container的中央(下面Icon吃的到)
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Align(
              //對其當前Container的底部中央
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