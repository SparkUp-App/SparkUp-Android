import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/event_card.dart';
import 'package:spark_up/data/list_receive_post.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/post_path.dart';

class EventShowPage extends StatefulWidget {
  const EventShowPage({super.key});

  @override
  State<EventShowPage> createState() => _EventShowPageState();
}

class _EventShowPageState extends State<EventShowPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "SparkUp",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF7AF8B),
        elevation: 2,
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: Column(
            children: [
              Container(
                height: 40.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {
                        
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Color(0xFF827C79),
                      ),
                    ),
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      color: Color(0xFF827C79),
                      fontSize: 14.0,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    suffixIcon: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: IconButton(
                        onPressed: () {
                          // Perform search logic here
                          print('Searching for: ${_searchController.text}');
                        },
                        icon: Icon(
                          Icons.menu,
                          color: const Color(0xFF827C79),
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Hot Event'),
                  Tab(text: 'For You'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HotContent(),
          ForYouContent(),
        ],
      ),
    );
  }
}

class HotContent extends StatefulWidget {
  const HotContent({super.key});

  @override
  State<HotContent> createState() => _HotContentState();
}

class _HotContentState extends State<HotContent>
    with AutomaticKeepAliveClientMixin {
  List<ListReceivePost> receivedPostList = [];
  final scrollController = ScrollController();
  bool isLoading = false;
  bool noMoreData = false;
  int page = 1, perPage = 20;
  late int pages;

  Future refresh() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});

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
    if (isLoading || noMoreData) return;
    isLoading = true;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: PostPath.list,
        pathMid: ["${Network.manager.userId}"],
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
  bool get wantKeepAlive => true;

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
    super.build(context);
    return Container(
        child: receivedPostList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  controller: scrollController,
                  children: [
                    for (var element in receivedPostList) ...[
                      eventCard(element, context)
                    ],
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (noMoreData) const Center(child: Text("No More Data"))
                  ],
                )));
  }
}

class ForYouContent extends StatefulWidget {
  const ForYouContent({super.key});

  @override
  State<ForYouContent> createState() => _ForYouContentState();
}

class _ForYouContentState extends State<ForYouContent>
    with AutomaticKeepAliveClientMixin {
  List<ListReceivePost> receivedPostList = [];
  final scrollController = ScrollController();
  bool isLoading = false;
  bool noMoreData = false;
  int page = 1, perPage = 20;
  late int pages;

  Future refresh() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});

    receivedPostList.clear();
    page = 1;
    noMoreData = false;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: PostPath.list,
        pathMid: ["${Network.manager.userId}"],
        data: {"page": page, "per_page": perPage, "sort": 0});

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
    if (isLoading || noMoreData) return;
    isLoading = true;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: PostPath.list,
        pathMid: ["${Network.manager.userId}"],
        data: {"page": page, "per_page": perPage, "sort": 0});

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
  bool get wantKeepAlive => true;

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
    super.build(context);
    return Container(
        child: receivedPostList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  controller: scrollController,
                  children: [
                    for (var element in receivedPostList) ...[
                      eventCard(element, context)
                    ],
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (noMoreData)
                      const Center(
                        child: Text("No More Data"),
                      ),
                  ],
                )));
  }
}
