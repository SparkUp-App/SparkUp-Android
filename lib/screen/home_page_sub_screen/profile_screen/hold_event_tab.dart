import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/event_card.dart';
import 'package:spark_up/data/list_receive_post.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/post_path.dart';

class HoldEventTab extends StatefulWidget {
  const HoldEventTab({super.key, required this.userId});

  final int userId;

  @override
  State<HoldEventTab> createState() => _HoldEventTadState();
}

class _HoldEventTadState extends State<HoldEventTab> with AutomaticKeepAliveClientMixin{
  late List<ListReceivePost> postList = [];
  int page = 1;
  int perPage = 20;
  late int pages;
  bool isEnd = false;
  bool isLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    getMoreData();
  }

  void getMoreData() async {
    if (isLoading || isEnd) return;

    isLoading = true;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: PostPath.list,
        pathMid: ["${widget.userId}"],
        data: {"user_id": widget.userId, "page": page, "per_page": perPage});

    if (context.mounted) {
      if (response["status"] == "success") {
        postList.addAll((response["data"]["posts"] as List<dynamic>)
            .map((element) => ListReceivePost.initfromData(element))
            .toList());
        pages = response["data"]["pages"];
        isEnd = page >= pages;
        page++;
      }
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: const Color(0xFFF7F2EF),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 50) {
            getMoreData();
          }
          return true;
        },
        child: ListView(
          children: [
            for (var element in postList) ...[eventCard(element, context)],
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (isEnd)
              const Center(
                child: Text("Normal Data"),
              )
          ],
        ),
      ),
    );
  }
}
