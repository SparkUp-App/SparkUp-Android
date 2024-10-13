import 'package:flutter/material.dart';
import 'package:spark_up/data/list_receive_post.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/post_path.dart';

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
        ));
  }
}

class HotContent extends StatefulWidget {
  const HotContent({super.key});

  @override
  State<HotContent> createState() => _HotContentState();
}

class _HotContentState extends State<HotContent> {
  List<ListReceivePost> receivedPostList = [];
  final scrollController = ScrollController();
  bool isLoading = false;
  bool noMoreData = false;
  int page = 1, perPage = 20;

  Future refresh() async {
    if (isLoading) return;
    isLoading = true;

    receivedPostList.clear();
    page = 1;
    noMoreData = false;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: PostPath.list,
        pathMid: ["${Network.manager.userId}"],
        data: {"page": page, "per_page": perPage});

    if (response["status"] == "success") {
      if (response["data"]["posts"].length == 0) {
        noMoreData = true;
      } else {
        List<Map> postList = List<Map>.from(response["data"]["posts"]);
        for (var post in postList) {
          receivedPostList.add(ListReceivePost.initfromData(post));
        }
        page++;
      }
    } else {
      //TODO Request Failed Process
    }

    isLoading = false;
    setState(() {});
    return;
  }

  Future getPost() async {
    if (isLoading) return;
    isLoading = true;

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: PostPath.list,
        pathMid: ["${Network.manager.userId}"],
        data: {"page": page, "per_page": perPage});

    if (response["status"] == "success") {
      if (response["data"]["posts"].length == 0) {
        noMoreData = true;
      } else {
        List<Map> postList = List<Map>.from(response["data"]["posts"]);
        for (var post in postList) {
          receivedPostList.add(ListReceivePost.initfromData(post));
        }
        page++;
      }
    } else {
      //TODO Request Failed Process
    }

    isLoading = false;
    setState(() {});
    return;
  }

  @override
  void initState() {
    super.initState();

    getPost();

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
    return Container(
        child: receivedPostList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: receivedPostList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < receivedPostList.length) {
                        return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: Center(
                                child: postCard(
                                    context, receivedPostList[index])));
                      } else {
                        return noMoreData
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Center(
                                  child: Text("No More Data"),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child:
                                    Center(child: CircularProgressIndicator()));
                      }
                    })));
  }
}

class FollowedContent extends StatefulWidget {
  const FollowedContent({super.key});

  @override
  State<FollowedContent> createState() => _FollowedContentState();
}

class _FollowedContentState extends State<FollowedContent> {
  List<ListReceivePost> receivedPostList = [];
  final scrollController = ScrollController();
  bool isLoading = false;
  bool noMoreData = false;
  int page = 1, perPage = 20;

  Future refresh() async {
    if (isLoading) return;
    isLoading = true;

    receivedPostList.clear();
    page = 1;
    noMoreData = false;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: PostPath.list,
        pathMid: ["${Network.manager.userId}"],
        data: {"page": page, "per_page": perPage, "sort" : 0});

    if (response["status"] == "success") {
      if (response["data"]["posts"].length == 0) {
        noMoreData = true;
      } else {
        List<Map> postList = List<Map>.from(response["data"]["posts"]);
        for (var post in postList) {
          receivedPostList.add(ListReceivePost.initfromData(post));
        }
        page++;
      }
    } else {
      //TODO Request Failed Process
    }

    isLoading = false;
    setState(() {});
    return;
  }

  Future getPost() async {
    if (isLoading) return;
    isLoading = true;

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: PostPath.list,
        pathMid: ["${Network.manager.userId}"],
        data: {"page": page, "per_page": perPage, "sort" : 0});

    if (response["status"] == "success") {
      if (response["data"]["posts"].length == 0) {
        noMoreData = true;
      } else {
        List<Map> postList = List<Map>.from(response["data"]["posts"]);
        for (var post in postList) {
          receivedPostList.add(ListReceivePost.initfromData(post));
        }
        page++;
      }
    } else {
      //TODO Request Failed Process
    }

    isLoading = false;
    setState(() {});
    return;
  }

  @override
  void initState() {
    super.initState();

    getPost();

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
    return Container(
        child: receivedPostList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: receivedPostList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < receivedPostList.length) {
                        return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: Center(
                                child: postCard(
                                    context, receivedPostList[index])));
                      } else {
                        return noMoreData
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Center(
                                  child: Text("No More Data"),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child:
                                    Center(child: CircularProgressIndicator()));
                      }
                    })));
  }
}

Widget postCard(BuildContext context, ListReceivePost receivedPost) {
  return Center(
      child: Card(
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                const Icon(
                  Icons.view_timeline,
                  color: Colors.grey,
                ),
                Text(
                  receivedPost.type,
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          Container(
              child: Text(
            "Poseter: ${receivedPost.posterNickname}",
            style: const TextStyle(color: Colors.black),
          )),
          Container(
              child: Row(
            children: [
              const Icon(
                Icons.timelapse,
                color: Colors.grey,
              ),
              Text(
                  "Event Start Date: ${receivedPost.eventStartDate.toIso8601String().split("T")[0]} ${receivedPost.eventStartDate.hour.toString().padLeft(2, "0")}:${receivedPost.eventStartDate.minute.toString().padLeft(2, "0")}")
            ],
          )),
          Container(
            child: Row(
              children: [
                const Icon(
                  Icons.timelapse,
                  color: Colors.grey,
                ),
                Text(
                    "Event End Date: ${receivedPost.eventEndDate.toIso8601String().split("T")[0]} ${receivedPost.eventEndDate.hour.toString().padLeft(2, "0")}:${receivedPost.eventEndDate.minute.toString().padLeft(2, "0")}")
              ],
            ),
          ),
          Container(
              child: Text(
            "Event Title: ${receivedPost.title}",
            style: const TextStyle(color: Colors.black),
          )),
          Container(
              child: Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Colors.grey,
              ),
              Text(
                "${receivedPost.likes}",
                style: const TextStyle(color: Colors.grey),
              ),
              const Icon(
                Icons.chat_bubble,
                color: Colors.grey,
              ),
              Text(
                "${receivedPost.comments}",
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ))
        ],
      ),
    ),
  ));
}
