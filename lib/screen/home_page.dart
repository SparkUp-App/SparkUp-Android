import 'package:flutter/material.dart';

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
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return CenterTest();
      case 1:
        return CenterTest();
      case 2:
        return CenterTest();
      case 3:
        return CenterTest();
      default:
        return CenterTest();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData dynamicTheme = ThemeData(
      appBarTheme: AppBarTheme(),
    );

    return Theme(
      data: dynamicTheme,
      child: Scaffold(
        body: _getPage(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '首頁',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: '行事曆',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: '課表',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services_outlined),
              label: '服務',
            ),
          ],
          currentIndex: _selectedIndex,
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