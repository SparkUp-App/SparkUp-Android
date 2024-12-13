import 'package:flutter/material.dart';
import 'package:spark_up/screen/home_page_sub_screen/book_mark_&_apply_screen/apply_tag.dart';
import 'package:spark_up/screen/home_page_sub_screen/book_mark_&_apply_screen/bookmark_tag.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage>
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
              color: Colors.white,
              fontFamily: "Kalam",
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF7AF8B),
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'BookMark'),
            Tab(text: 'Apply'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [BookMarkTag(), ApplyTag()],
      ),
    );
  }
}
