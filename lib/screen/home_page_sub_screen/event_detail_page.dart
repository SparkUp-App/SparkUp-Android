import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/post_path.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key, required this.postId});

  final int postId;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage>
    with SingleTickerProviderStateMixin {
  bool initialing = false;
  late BasePost postData;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    initDataGet(context);
  }

  Future initDataGet(context) async {
    setState(() {
      initialing = true;
    });

    final response = await Network.manager.sendRequest(
      method: RequestMethod.post,
      path: PostPath.view,
      data: {"user_id": Network.manager.userId, "post_id": widget.postId},
    );

    if (context.mounted) {
      if (response["status"] == "success") {
        postData = BasePost.initfromData(response["data"]);
      } else {
        showDialog(
          context: context,
          builder: (context) => SystemMessage(
            content: "${response["data"]["message"]}",
          ),
        );
      }
    }

    setState(() {
      initialing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initialing
          ? const Center(child: CircularProgressIndicator())
          : NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: const Color.fromARGB(255, 245, 174, 128),
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30.0,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => setState(() {
                          postData.liked = !postData.liked!;
                        }),
                        icon: Icon(
                          postData.liked!
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: const Color.fromARGB(255, 233, 113, 153),
                          size: 30.0,
                        ),
                      ),
                    ],
                    expandedHeight: 200.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.view_timeline,
                                  color: Colors.grey,
                                ),
                                Text(
                                  postData.type,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              postData.title,
                              style: const TextStyle(fontSize: 30.0),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "${postData.likes}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const Icon(
                                  Icons.chat_bubble,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "${postData.comments}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    bottom: TabBar(
                      controller: tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.7),
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(text: "Detail"),
                        Tab(text: "Comment"),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: tabController,
                children: const [
                  Center(child: Text("Page in Programming")),
                  Center(child: Text("Page in programming")),
                ],
              ),
            ),
    );
  }
}
