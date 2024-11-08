import 'package:flutter/material.dart';
import "package:spark_up/common_widget/exit_dialog.dart";
import "package:spark_up/common_widget/spark_Icon.dart";
import "package:spark_up/screen/home_page_sub_screen/book_mark_&_apply_screen/bookmark_page.dart";
import "package:spark_up/screen/home_page_sub_screen/event_show_page.dart";
import "package:spark_up/screen/home_page_sub_screen/notification_screen/notification_page.dart";
import "package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_decide.dart";
import "package:spark_up/screen/home_page_sub_screen/profile_screen/profile_show_page.dart";
import 'package:spark_up/network/network.dart';

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
                builder: () => const CenterTest(),
              ),
              LazyLoadPage(
                shouldBuild: _hasVisited[3],
                builder: () => ProfileShowPage(
                  userId: Network.manager.userId!,
                  editable: true,
                ),
              ),
            ],
          ),
          floatingActionButton: Visibility(
            visible: !_isKeyboardVisible,
            child: Container(
              margin: const EdgeInsets.only(top: 25),
              width: 55,
              height: 55,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const sparkPageEventTypeDecide(),
                  ));
                },
                backgroundColor: Color.fromARGB(255, 255, 197, 170),
                elevation: 0.0,
                child: Image.asset(
                  'assets/sparkUpMainIcon.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar:Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
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
        )
    );
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
