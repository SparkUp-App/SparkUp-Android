import 'package:flutter/material.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/route.dart';

void main() {
  Network();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SparkUp",
      debugShowCheckedModeBanner: false,
      routes: RouteMap.routes,
      initialRoute: RouteMap.eventTypeProfilePage,//testing home_page , initial used to be loginPage
      //如果你想要測試"註冊完轉到initial個人資訊的頁面"，call RouteMap.initialProfileDataPage,
    );
  }
}
