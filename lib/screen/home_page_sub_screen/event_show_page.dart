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
  late List<String> selectType = [];
  late String searchKeyWord;
  bool filterMode = false;

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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
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
                        onPressed: () {},
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
                            setState(() {
                              filterMode = !filterMode;
                            });
                          },
                          icon: Icon(
                            (filterMode ? Icons.cancel_outlined : Icons.menu),
                            color: const Color(0xFF827C79),
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (filterMode)
                  const SizedBox(
                    height: 50.0,
                  ),
                if (!filterMode)
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
        body: (filterMode
            ? const FilterPage()
            : TabBarView(
                controller: _tabController,
                children: const [
                  HotContent(),
                  ForYouContent(),
                ],
              )));
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

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final List<Map<String, String>> eventTypes = [
    {"name": "Competition", "path": 'assets/event/competition.jpg'},
    {"name": "Roommate", "path": 'assets/event/roommates.jpg'},
    {"name": "Sport", "path": 'assets/event/sports.jpg'},
    {"name": "Study", "path": 'assets/event/study.jpg'},
    {"name": "Social", "path": 'assets/event/social.jpg'},
    {"name": "Travel", "path": 'assets/event/travel.jpg'},
    {"name": "Meal", "path": 'assets/event/meal.jpg'},
    {"name": "Speech", "path": 'assets/event/speech.jpg'},
    {"name": "Parade", "path": 'assets/event/parade.jpg'},
    {"name": "Exhibition", "path": 'assets/event/exhibition.jpg'},
  ];
  late List<String> selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = [];
  }


  Widget eventTypeContainer(String eventName, String imagePath) {
    bool isSelected = selectedType.contains(eventName);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedType.remove(eventName);
          } else {
            selectedType.add(eventName);
          }
        });
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200], // 添加預設背景色
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                cacheWidth: 140 * 2,
                cacheHeight: 140 * 2,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected
                    ? Colors.white.withOpacity(0.8)
                    : Colors.black.withOpacity(0.3),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Color(0xFFF16743),
                size: 80,
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  eventName,
                  style: TextStyle(
                    fontFamily: 'IowanOldStyle',
                    color: isSelected ? const Color(0xFFF16743) : Colors.white,
                    fontSize: eventName.length >= 8 ? 18 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            color: const Color(0xFFF7AF8B).withOpacity(0.3),
            child: Stack(children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  //會自動偵測，避免超過看的到的地方
                  child: Stack(children: [
                    SingleChildScrollView(
                      //一次load好比ListView慢load好
                      child: SizedBox(
                          child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                eventTypeContainer("Competition",
                                    'assets/event/competition.jpg'),
                                const SizedBox(height: 20),
                                eventTypeContainer(
                                    "Roommate", 'assets/event/roommates.jpg'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                eventTypeContainer(
                                    "Sport", 'assets/event/sports.jpg'),
                                const SizedBox(height: 20),
                                eventTypeContainer(
                                    "Study", 'assets/event/study.jpg'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                eventTypeContainer(
                                    "Social", 'assets/event/social.jpg'),
                                const SizedBox(height: 20),
                                eventTypeContainer(
                                    "Travel", 'assets/event/travel.jpg'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                eventTypeContainer(
                                    "Meal", 'assets/event/meal.jpg'),
                                const SizedBox(height: 20),
                                eventTypeContainer(
                                    "Speech", 'assets/event/speech.jpg'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                eventTypeContainer(
                                    "Parade", 'assets/event/parade.jpg'),
                                const SizedBox(height: 20),
                                eventTypeContainer("Exhibition",
                                    'assets/event/exhibition.jpg'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 120,
                          ),
                        ],
                      )),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 100, // 設置背景的高度
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: 150,
                          height: 47,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF7AF8B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Search',
                              style: TextStyle(
                                fontFamily: 'IowanOldStyle',
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
          );
  }
}
