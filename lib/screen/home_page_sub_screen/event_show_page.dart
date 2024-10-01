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
          automaticallyImplyLeading: false,
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
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "熱門"),
              Tab(text: "For You"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HotContent(),
            FollowedContent(),
          ],
        ),
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

class FollowedContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('這是追蹤內容', style: TextStyle(fontSize: 24)),
    );
  }
}