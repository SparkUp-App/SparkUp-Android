import 'package:flutter/material.dart';
import 'package:spark_up/screen/home_page_sub_screen/notification_screen/message_tag.dart';
import 'package:spark_up/screen/home_page_sub_screen/notification_screen/request_tag.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "SparkUp!",
            style: TextStyle(
              color: Color(0xFFF77D43),
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
              fontFamily: "Kalam",
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontSize: 14.0),
          labelColor: Colors.black,
          unselectedLabelColor: const Color(0xFF827C79),
          indicatorColor: const Color(0xFFF5A278),
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Message'),
            Tab(text: 'Request'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [MessageTag(), RequestTag()],
      ),
    );
  }
}
