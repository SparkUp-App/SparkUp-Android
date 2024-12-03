import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/event_card.dart';
import 'package:spark_up/data/list_receive_post.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/post_path.dart';
import 'package:spark_up/common_widget/event_card_skeleton.dart';
import 'package:spark_up/common_widget/no_more_data.dart';

class HoldEventTab extends StatefulWidget {
  const HoldEventTab({super.key, required this.userId});

  final int userId;

  @override
  State<HoldEventTab> createState() => _HoldEventTadState();
}

class _HoldEventTadState extends State<HoldEventTab>
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

  void refresh() {
    if (isLoading) return;
    page = 1;
    isEnd = false;
    postList.clear();
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
        child: postList.isEmpty
    ?  Center(
  child: SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min, // 讓內容根據內容大小適配
      children: [
        Image.asset(
          'assets/No_Event_space.png', // 替換為你的 PNG 圖片路徑
          width: MediaQuery.of(context).size.width * 0.9, // 寬度設置為屏幕的 90%
          height: MediaQuery.of(context).size.height * 0.35,
          fit: BoxFit.contain, // 確保圖片不會變形
        ),
        const SizedBox(height: 16), // 圖片與文字之間的間距
        const Text(
          "You haven’t post any events yet.",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center, // 確保文字居中
        ),
      ],
    ),
  ),
  )   
    : ListView.builder(
        itemCount: postList.length + (isLoading ? 1 : 0) + (isEnd ? 1 : 0), // 計算總項目數
        itemBuilder: (context, index) {
          if (index < postList.length) {
            // 顯示普通的 eventCard
            return eventCard(postList[index], context, refresh);
          } else if (isLoading && index == postList.length) {
            // 加載中顯示骨架屏
            return eventCardSkeletonList();
          } else if (isEnd && index == postList.length + (isLoading ? 1 : 0)) {
            // 已加載到底時顯示 "沒有更多數據"
            return const NoMoreData();
          }
          return const SizedBox.shrink(); // 默認情況，防止意外
        },
      ),
      ),
    );
  }
}
