import 'package:flutter/material.dart';
import "package:spark_up/common_widget/exit_dialog.dart";
import "package:spark_up/screen/home_page_sub_screen/book_mark_&_apply_screen/bookmark_page.dart";
import "package:spark_up/screen/home_page_sub_screen/event_show_page.dart";
import "package:spark_up/screen/home_page_sub_screen/profile_screen/profile_page.dart";
import "package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page.dart";
import "package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_decide.dart";
import "package:spark_up/screen/home_page_sub_screen/profile_screen/profile_show_page.dart";
import 'package:spark_up/network/network.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index == 2) return; // Ignore taps on the middle item
    setState(() {
      _selectedIndex = index < 2 ? index : index - 1;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return EventShowPage(key: UniqueKey());
      case 1:
        return const BookmarkPage();
      case 2:
        return CenterTest();
      case 3:
        return ProfileShowPage(userId:Network.manager.userId!, editable: true,);
      default:
        return CenterTest();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await showDialog(
          context: context,
          builder: (context) => const ExitConfirmationDialog(),
        );
    },
      child:Scaffold(
        body: _getPage(_selectedIndex),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(top: 25),
          width: 55,
          height: 55,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => sparkPageEventTypeDecide(),
              ));
            },
            child: Icon(Icons.add, size: 30),
            elevation: 4.0,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'BookMarks',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(width: 40), // Placeholder for FAB
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services_outlined),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex < 2 ? _selectedIndex : _selectedIndex + 1,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      
    ),
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
    return Center();
  }
}