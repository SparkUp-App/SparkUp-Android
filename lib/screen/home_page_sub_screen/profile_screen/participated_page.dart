import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/empty_view.dart';
import 'package:spark_up/common_widget/event_card.dart';
import 'package:spark_up/common_widget/event_card_skeleton.dart';
import 'package:spark_up/common_widget/no_more_data.dart';
import 'package:spark_up/data/list_receive_post.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/user_path.dart';

class ParticipatedPage extends StatefulWidget {
  const ParticipatedPage({super.key, required this.userId});

  final int userId;

  @override
  State<ParticipatedPage> createState() => _ParticipatedPageState();
}

class _ParticipatedPageState extends State<ParticipatedPage> {
  List<ListReceivePost> receivedPostList = [];
  final scrollController = ScrollController();
  bool isLoading = false;
  bool noMoreData = false;
  int page = 1, perPage = 20;
  late int pages;

  Future refresh() async {
    if (isLoading) return;
    isLoading = true;
    receivedPostList.clear();
    page = 1;
    noMoreData = false;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: UserPath.participated,
        pathMid: ["${widget.userId}"],
        data: {"page": page, "per_page": perPage});

    if (response["status"] == "success") {
      List<Map> postList = List<Map>.from(response["data"]["posts"]);
      for (var post in postList) {
        receivedPostList.add(ListReceivePost.initfromData(post));
      }
      pages = response["data"]["pages"];
      noMoreData = page >= pages;
      page++;
    } else {
      //TODO Request Failed Process
    }

    isLoading = false;
    setState(() {});
    return;
  }

  Future getPost() async {
    if (isLoading || noMoreData) return;
    isLoading = true;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: UserPath.participated,
        pathMid: ["${widget.userId}"],
        data: {"page": page, "per_page": perPage});

    if (response["status"] == "success") {
      List<Map> postList = List<Map>.from(response["data"]["posts"]);
      for (var post in postList) {
        receivedPostList.add(ListReceivePost.initfromData(post));
      }
      pages = response["data"]["pages"];
      noMoreData = page >= pages;
      page++;
    }

    isLoading = false;
    setState(() {});
    return;
  }

  @override
  void initState() {
    super.initState();
    refresh();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        getPost();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          "Participated",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF7AF8B),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            refresh();
          },
          child: receivedPostList.isEmpty && !isLoading
              ? const EmptyView(content: "Join an event in home page")
              : ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  children: [
                    for (var element in receivedPostList) ...[
                      eventCard(element, context, () {})
                    ],
                    if (isLoading) const eventCardSkeletonList(),
                    if (noMoreData) const NoMoreData(),
                  ],
                )),
    );
  }
}
