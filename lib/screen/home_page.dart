import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import "package:spark_up/chat/chat_room_manager.dart";
import "package:spark_up/common_widget/exit_dialog.dart";
import "package:spark_up/common_widget/spark_Icon.dart";
import "package:spark_up/screen/home_page_sub_screen/book_mark_&_apply_screen/bookmark_page.dart";
import "package:spark_up/screen/home_page_sub_screen/event_show_page.dart";
import "package:spark_up/screen/home_page_sub_screen/notification_screen/notification_page.dart";
import "package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_decide.dart";
import "package:spark_up/screen/home_page_sub_screen/profile_screen/profile_show_page.dart";
import 'package:spark_up/network/network.dart';
import "package:spark_up/socket_service.dart";

class LazyLoadPage extends StatefulWidget {
  final Widget Function() builder;
  final bool shouldBuild;

  const LazyLoadPage({
    super.key,
    required this.builder,
    required this.shouldBuild,
  });

  @override
  State<LazyLoadPage> createState() => _LazyLoadPageState();
}

class _LazyLoadPageState extends State<LazyLoadPage> {
  Widget? _cached;

  @override
  Widget build(BuildContext context) {
    if (!widget.shouldBuild) {
      return Container();
    }

    _cached ??= widget.builder();
    return _cached!;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<bool> _hasVisited = [false, false, false, false];

  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _hasVisited[0] = true;
  }

  void _onItemTapped(int index) {
    if (index == 2) return;
    final actualIndex = index < 2 ? index : index - 1;

    setState(() {
      _selectedIndex = actualIndex;
      _hasVisited[actualIndex] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isKeyboardVisible;
      });
    }
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          await showDialog(
            context: context,
            builder: (context) => const ExitConfirmationDialog(),
          );
        },
        child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              LazyLoadPage(
                shouldBuild: _hasVisited[0],
                builder: () => const EventShowPage(),
              ),
              LazyLoadPage(
                shouldBuild: _hasVisited[1],
                builder: () => const BookmarkPage(),
              ),
              LazyLoadPage(
                shouldBuild: _hasVisited[2],
                builder: () => const NotificationPage(),
              ),
              LazyLoadPage(
                shouldBuild: _hasVisited[3],
                builder: () => ProfileShowPage(
                  userId: Network.manager.userId!,
                  editable: true,
                  fromHomePage: true,
                ),
              ),
            ],
          ),
          resizeToAvoidBottomInset: true,
          floatingActionButton: Container(
            margin: const EdgeInsets.only(top: 25),
            width: 65,
            height: 65,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const sparkPageEventTypeDecide(),
                ));
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
              child: const Icon(
                Icons.add_circle_rounded,
                color: Color(0xFFF77D43),
                size: 50.0,
              ),
            ),
          ),
          floatingActionButtonLocation:
              const _NoBounceDockedCenterFabLocation(),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              elevation: 1.0,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SparkIcon(
                    icon: SparkIcons.homeBorder,
                    color: Color(0xFF827C79),
                    size: 25.0,
                  ),
                  activeIcon: SparkIcon(
                    icon: SparkIcons.home,
                    color: Color(0xFFF77D43),
                    size: 25.0,
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: SparkIcon(
                    icon: SparkIcons.bookmarkBorder,
                    color: Color(0xFF827C79),
                    size: 25.0,
                  ),
                  activeIcon: SparkIcon(
                    icon: SparkIcons.bookmark,
                    color: Color(0xFFF77D43),
                    size: 25.0,
                  ),
                  label: 'BookMarks',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(width: 40), // Placeholder for FAB
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: SparkIcon(
                    icon: SparkIcons.messageBorder,
                    color: Color(0xFF827C79),
                    size: 25.0,
                  ),
                  activeIcon: SparkIcon(
                    icon: SparkIcons.message,
                    color: Color(0xFFF77D43),
                    size: 25.0,
                  ),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                  icon: SparkIcon(
                    icon: SparkIcons.userBorder,
                    color: Color(0xFF827C79),
                    size: 25.0,
                  ),
                  activeIcon: SparkIcon(
                    icon: SparkIcons.user,
                    color: Color(0xFFF77D43),
                    size: 25.0,
                  ),
                  label: 'Profile',
                ),
              ],
              currentIndex:
                  _selectedIndex < 2 ? _selectedIndex : _selectedIndex + 1,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
            ),
          ),
        ));
  }
}

class CenterTest extends StatefulWidget {
  const CenterTest({super.key});

  @override
  State<CenterTest> createState() => _CenterTestState();
}

class _CenterTestState extends State<CenterTest> {
  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}

class _NoBounceDockedCenterFabLocation extends FloatingActionButtonLocation {
  const _NoBounceDockedCenterFabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // 計算 x 座標 (置中)
    final double fabX = (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2;

    // 計算 y 座標 (底部停靠)
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height / 2 -
        kBottomNavigationBarHeight * 1.2; // 使用固定高度

    return Offset(fabX, fabY);
  }
}
