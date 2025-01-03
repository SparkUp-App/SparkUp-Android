import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/empty_view.dart';
import 'package:spark_up/common_widget/event_card.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/list_receive_post.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/user_path.dart';
import 'package:spark_up/common_widget/no_more_data.dart';
import 'package:spark_up/common_widget/event_card_skeleton.dart';

class ApplyTag extends StatefulWidget {
  const ApplyTag({super.key});

  @override
  State<ApplyTag> createState() => _ApplyTagState();
}

class _ApplyTagState extends State<ApplyTag>
    with AutomaticKeepAliveClientMixin {
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
        path: UserPath.applied,
        pathMid: ["${Network.manager.userId}"],
        data: {"page": page, "per_page": perPage});

    if (context.mounted) {
      if (response["status"] == "success") {
        postList.addAll((response["data"]["posts"] as List<dynamic>)
            .map((element) => ListReceivePost.initfromData(element))
            .toList());
        pages = response["data"]["pages"];
        isEnd = page >= pages;
        page++;
      } else if (response["status"] == "error") {
        switch (response["data"]["message"]) {
          case "Timeout Error":
            showDialog(
                context: context,
                builder: (context) => const SystemMessage(
                    title: "Timeout error",
                    content:
                        "The response time is too long, please check the connection and try againg later."));
            break;
          case "Connection Error":
            showDialog(
                context: context,
                builder: (context) => const SystemMessage(
                    title: "Connection error",
                    content:
                        "The connection is unstable, please check the connection and try again later."));
            break;
          default:
            showDialog(
                context: context,
                builder: (context) => const SystemMessage(
                    title: "Local error",
                    content:
                        "An unexpected local error occured, please contact us or try again later."));
            break;
        }
      } else if (response["status"] == "faild") {
        switch (response["status_code"]) {
          default:
            showDialog(
                context: context,
                builder: (context) => const SystemMessage(
                    title: "Server error",
                    content:
                        "An unexpected server error occured, please contact us or try againg later."));
            break;
        }
      } else {
        showDialog(
            context: context,
            builder: (context) => const SystemMessage(
                title: "Error",
                content:
                    "An unexpected error occured, please contact us or try again later."));
      }
    }

    isLoading = false;
    setState(() {});
  }

  Future refresh() async {
    postList.clear();
    page = 1;
    isEnd = false;
    getMoreData();
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
        child: RefreshIndicator(
          onRefresh: refresh,
          child: postList.isEmpty && !isLoading
              ? const EmptyView(
                  content: "Apply an event in the event detail page.")
              : ListView(
                  children: [
                    for (var element in postList) ...[
                      eventCard(element, context, refresh,
                          reviewStatusShow: true),
                    ],
                    if (isLoading)
                      const Center(
                        child: EventCardSkeletonListRandomLength(),
                      ),
                    if (isEnd) const NoMoreData(),
                  ],
                ),
        ),
      ),
    );
  }
}
