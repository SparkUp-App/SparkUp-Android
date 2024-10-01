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
      title: "SparUp",
      debugShowCheckedModeBanner: false,
      routes: RouteMap.routes,
      initialRoute: RouteMap.homePage,//testing home_page , initial used to be loginPage
    );
  }
}
