import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/event_card.dart';
import 'package:spark_up/common_widget/event_card_skeleton.dart';
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
  late ValueNotifier<List<String>> selectTypeNotifier;
  late ValueNotifier<String> searchKeyWord;
  bool filterMode = false;
  late ValueNotifier<bool> searchNeededNotifier;
  late String currentSearchKeyWord;
  late List<String> currentSelectType;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    selectTypeNotifier = ValueNotifier<List<String>>([]);
    searchKeyWord = ValueNotifier<String>("");
    searchNeededNotifier = ValueNotifier<bool>(false);
    currentSearchKeyWord = "";
    currentSelectType = [];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void cancelMenuPressed() {
    if (filterMode) {
      searchKeyWord.value = "";
      _searchController.clear();
      selectTypeNotifier.value = [];
      if (currentSearchKeyWord != searchKeyWord.value ||
          !listEquals(currentSelectType, selectTypeNotifier.value)) {
        searchNeededNotifier.value = !searchNeededNotifier.value;
        currentSearchKeyWord = searchKeyWord.value;
        currentSelectType = selectTypeNotifier.value;
      }
      setState(() {
        filterMode = false;
      });
    } else {
      setState(() {
        filterMode = true;
      });
    }
  }

  void searchIconPressed() {
    searchKeyWord.value = _searchController.text.trim();
    if (currentSearchKeyWord != searchKeyWord.value ||
        !listEquals(currentSelectType, selectTypeNotifier.value)) {
      searchNeededNotifier.value = !searchNeededNotifier.value;
      currentSearchKeyWord = searchKeyWord.value;
      currentSelectType = selectTypeNotifier.value;
    }

    setState(() {
      if (filterMode) filterMode = false;
    });
  }

  void searchButtonPressed() {
    searchKeyWord.value = _searchController.text.trim();
    if (currentSearchKeyWord != searchKeyWord.value ||
        !listEquals(currentSelectType, selectTypeNotifier.value)) {
      searchNeededNotifier.value = !searchNeededNotifier.value;
      currentSearchKeyWord = searchKeyWord.value;
      currentSelectType = selectTypeNotifier.value;
    }
    setState(() {
      filterMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
        valueListenable: selectTypeNotifier,
        builder: (context, selectType, child) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Center(
                  child: Text(
                    "SparkUp",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Kalam",
                    ),
                  ),
                ),
                backgroundColor: const Color(0xFFF7AF8B),
                elevation: 2,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(
                    (() {
                      if (selectTypeNotifier.value.isEmpty) {
                        return 90.0;
                      } 
                      else {
                        return 130.0;
                      }
                    })(),
                  ),
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
                              onPressed: searchIconPressed,
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
                                onPressed: cancelMenuPressed,
                                icon: Icon(
                                  (filterMode
                                      ? Icons.cancel_outlined
                                      : Icons.menu),
                                  color: const Color(0xFF827C79),
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ),
                          onTap: () => setState(() {
                            filterMode = true;
                          }),
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            searchIconPressed();
                          },
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 5.0),
                            child: Container(
                              height: selectTypeNotifier.value.isNotEmpty
                                  ? null
                                  : 0,
                              child: Wrap(
                                spacing: 6.0,
                                runSpacing: 6.0,
                                children: selectTypeNotifier.value.map((type) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFADADAD)
                                          .withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            type,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                          Container(
                                            height: 40,
                                            width: 35,
                                            child: IconButton(
                                              iconSize: 10,
                                              onPressed: () => setState(() {
                                                selectTypeNotifier.value =
                                                    List.from(selectTypeNotifier
                                                        .value)
                                                      ..remove(type);
                                                if (!filterMode) {
                                                  currentSelectType =
                                                      selectTypeNotifier.value;
                                                  searchNeededNotifier.value =
                                                      !searchNeededNotifier
                                                          .value;
                                                }
                                              }),
                                              icon: const Icon(Icons.close,
                                                  color: Colors.black38),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
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
              body: Stack(
                children: [
                  TabBarView(
                    controller: _tabController,
                    children: [
                      HotContent(
                        searchNeededNotifier: searchNeededNotifier,
                        selectType: selectTypeNotifier,
                        searchKeyWord: searchKeyWord,
                      ),
                      ForYouContent(
                        selectType: selectTypeNotifier,
                        searchKeyWord: searchKeyWord,
                        searchNeededNotifier: searchNeededNotifier,
                      )
                    ],
                  ),
                  if (filterMode) ...[
                    Positioned.fill(
                      child: FilterPage(
                        selectTypeNotifier: selectTypeNotifier,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 100,
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: 150,
                          height: 47,
                          child: ElevatedButton(
                            onPressed: searchButtonPressed,
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
                  ]
                ],
              ));
        });
  }
}

class HotContent extends StatefulWidget {
  const HotContent(
      {super.key,
      required this.selectType,
      required this.searchKeyWord,
      required this.searchNeededNotifier});

  final ValueNotifier<List<String>> selectType;
  final ValueNotifier<String> searchKeyWord;
  final ValueNotifier<bool> searchNeededNotifier;

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
    receivedPostList.clear();
    page = 1;
    noMoreData = false;
    setState(() {});

    final response = await Network.manager
        .sendRequest(method: RequestMethod.post, path: PostPath.list, pathMid: [
      "${Network.manager.userId}"
    ], data: {
      "page": page,
      "per_page": perPage,
      "type": widget.selectType.value,
      "keyword":
          widget.searchKeyWord.value.isEmpty ? null : widget.searchKeyWord.value
    });

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

    final response = await Network.manager
        .sendRequest(method: RequestMethod.post, path: PostPath.list, pathMid: [
      "${Network.manager.userId}"
    ], data: {
      "page": page,
      "per_page": perPage,
      "type": widget.selectType.value,
      "keyword":
          widget.searchKeyWord.value.isEmpty ? null : widget.searchKeyWord.value
    });

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

    widget.searchNeededNotifier.addListener(() {
      refresh();
    });
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

    widget.searchNeededNotifier.removeListener(() {
      refresh();
    });
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: RefreshIndicator(
            onRefresh: ()async{refresh();},
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              children: [
                for (var element in receivedPostList) ...[
                  eventCard(element, context)
                ],
                if (isLoading) eventCardSkeletonList(),
                if (noMoreData) const Center(child: Text("No More Data"))
              ],
            )));
  }
}

class ForYouContent extends StatefulWidget {
  const ForYouContent(
      {super.key,
      required this.selectType,
      required this.searchKeyWord,
      required this.searchNeededNotifier});

  final ValueNotifier<List<String>> selectType;
  final ValueNotifier<String> searchKeyWord;
  final ValueNotifier<bool> searchNeededNotifier;

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

    final response = await Network.manager
        .sendRequest(method: RequestMethod.post, path: PostPath.list, pathMid: [
      "${Network.manager.userId}"
    ], data: {
      "page": page,
      "per_page": perPage,
      "type": widget.selectType.value,
      "keyword": widget.searchKeyWord.value.isEmpty
          ? null
          : widget.searchKeyWord.value,
      "sort": 0
    });

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

    final response = await Network.manager
        .sendRequest(method: RequestMethod.post, path: PostPath.list, pathMid: [
      "${Network.manager.userId}"
    ], data: {
      "page": page,
      "per_page": perPage,
      "type": widget.selectType.value,
      "keyword": widget.searchKeyWord.value.isEmpty
          ? null
          : widget.searchKeyWord.value,
      "sort": 0
    });

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

    widget.searchNeededNotifier.addListener(() {
      refresh();
    });
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

    widget.searchNeededNotifier.removeListener(() {
      refresh();
    });
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: RefreshIndicator(
            onRefresh:()async{refresh();},
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              children: [
                for (var element in receivedPostList) ...[
                  eventCard(element, context)
                ],
                if (isLoading) eventCardSkeletonList(),
                if (noMoreData)
                  const Center(
                    child: Text("No More Data"),
                  ),
              ],
            )));
  }
}

class FilterPage extends StatefulWidget {
  FilterPage({super.key, required this.selectTypeNotifier});

  late ValueNotifier<List<String>> selectTypeNotifier;
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

  Widget eventTypeContainer(String eventName, String imagePath) {
    bool isSelected = widget.selectTypeNotifier.value.contains(eventName);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            widget.selectTypeNotifier.value =
                List.from(widget.selectTypeNotifier.value)..remove(eventName);
          } else {
            widget.selectTypeNotifier.value =
                List.from(widget.selectTypeNotifier.value)..add(eventName);
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
    return ValueListenableBuilder<List<String>>(
      valueListenable: widget.selectTypeNotifier,
      builder: (context, selectType, child) {
        return Container(
          color: const Color.fromARGB(255, 255, 225, 209).withOpacity(0.5),
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    eventTypeContainer("Competition",
                                        'assets/event/competition.jpg'),
                                    const SizedBox(height: 20),
                                    eventTypeContainer("Roommate",
                                        'assets/event/roommates.jpg'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    eventTypeContainer(
                                        "Parade", 'assets/event/parade.jpg'),
                                    const SizedBox(height: 20),
                                    eventTypeContainer("Exhibition",
                                        'assets/event/exhibition.jpg'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
