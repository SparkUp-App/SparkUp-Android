import 'package:flutter/material.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/route.dart';

void main() {
  Network();
  runApp(const ImagePrecacheWrapper());
}

class ImagePrecacheWrapper extends StatefulWidget {
  const ImagePrecacheWrapper({super.key});

  @override
  State<ImagePrecacheWrapper> createState() => _ImagePrecacheWrapperState();
}

class _ImagePrecacheWrapperState extends State<ImagePrecacheWrapper> {
  bool _imagesLoaded = false;

  static const List<String> eventImages = [
    'assets/event/competition.jpg',
    'assets/event/roommates.jpg',
    'assets/event/sports.jpg',
    'assets/event/study.jpg',
    'assets/event/social.jpg',
    'assets/event/travel.jpg',
    'assets/event/meal.jpg',
    'assets/event/speech.jpg',
    'assets/event/parade.jpg',
    'assets/event/exhibition.jpg',
    'assets/sparkUpMainIcon.png'
  ];

  @override
  void initState() {
    super.initState();
    _precacheImages();
  }

  Future<void> _precacheImages() async {
    try {
      await Future.wait(
        eventImages.map((path) => precacheImage(
              AssetImage(path),
              context,
            )),
      );
      setState(() {
        _imagesLoaded = true;
      });
    } catch (e) {
      debugPrint('Error precaching images: $e');
      setState(() {
        _imagesLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_imagesLoaded) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SparkUp",
      debugShowCheckedModeBanner: false,
      routes: RouteMap.routes,
      initialRoute: RouteMap.loginPage,
    );
  }
}
