import 'package:flutter/material.dart';
import 'package:spark_up/data/profile.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/profile_path.dart';
import 'package:spark_up/route.dart';
import 'package:spark_up/secure_storage.dart';

String? userId;
String? noProfile;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<String?> result = await Future.wait([
    SecureStorage.read(StoreKey.userId),
    SecureStorage.read(StoreKey.noProfile)
  ]);
  userId = result[0];
  noProfile = result[1];

  if (userId != null) Network.manager.userId = int.parse(userId!);
  if(noProfile == "Yes"){
    Profile.manager = Profile.initfromDefault();
  }
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
        initialRoute: Network.manager.userId == null
            ? RouteMap.loginPage
            : noProfile == "Yes"
                ? RouteMap.initialProfileDataPage
                : RouteMap.homePage);
  }
}
