import 'package:flutter/material.dart';

class EventShowPage extends StatefulWidget {
  const EventShowPage({super.key});

  @override
  State<EventShowPage> createState() => _EventShowPageState();
}

class _EventShowPageState extends State<EventShowPage> {
  @override
Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "SparkUp!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                ),
              ),
            backgroundColor: Colors.redAccent,
            elevation: 2,
            bottom: TabBar(
                labelColor: Colors.redAccent,
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("熱門"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("For You"),
                    ),
                  ),
                ]
            ),
          ),
          body: TabBarView(children: [
            Icon(Icons.apps),
            Icon(Icons.movie),
          
          ]),
        )
     );
}
}

class HotContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('這是熱門文章內容', style: TextStyle(fontSize: 24)),
    );
  }
}

class LatestContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('這是最新文章內容', style: TextStyle(fontSize: 24)),
    );
  }
}

class FollowedContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('這是追蹤內容', style: TextStyle(fontSize: 24)),
    );
  }
}