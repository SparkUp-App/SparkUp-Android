import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/data/comment.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/comment_path.dart';
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
  bool sendingLike = false;
  bool sendingBookMark = false;
  bool sendingMessage = false;
  bool gettingComment = false;
  bool noMoreComment = false;

  late BasePost postData;
  late TabController tabController;

  List<Comment> commentList = [];
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  int page = 2, perPage = 20;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    initDataGet(context);
    tabController.addListener(() {
      if (tabController.index == 1) {
        scrollController.addListener(() {
          if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
            getComment();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  Future initDataGet(context) async {
    setState(() {
      initialing = true;
    });

    //Init Post Data Get
    var response = await Network.manager.sendRequest(
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

    //Init Post Comment Data Get
    response = await Network.manager
        .sendRequest(method: RequestMethod.post, path: CommentPath.list, data: {
      "user_id": Network.manager.userId,
      "post_id": postData.postId,
      "page": 1,
      "per_page": perPage
    });

    if (context.mounted) {
      if (response["status"] == "success") {
        for (var data in response["data"]["comments"]) {
          commentList.add(Comment.initfromData(data));
        }
      } else {
        showDialog(
            context: context,
            builder: (context) =>
                SystemMessage(content: "${response["data"]["mesage"]}"));
      }
    }

    setState(() {
      initialing = false;
    });
  }

  void pressLikedProcess() async {
    if (sendingLike) return;

    sendingLike = true;

    final response = await Network.manager
        .sendRequest(method: RequestMethod.post, path: PostPath.like, data: {
      "user_id": Network.manager.userId,
      "post_id": postData.postId,
      "retrieve": postData.liked
    });

    if (context.mounted) {
      if (response["status"] == "success") {
        setState(() {
          postData.liked = !postData.liked!;
        });
      } else {
        showDialog(
            context: context,
            builder: (context) =>
                SystemMessage(content: "${response["data"]["message"]}"));
      }
    }

    sendingLike = false;
  }

  void pressBookMarkedProcess() async {
    if (sendingBookMark) return;
    sendingBookMark = true;

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: PostPath.bookmark,
        data: {
          "user_id": Network.manager.userId,
          "post_id": postData.postId,
          "retrieve": postData.bookmarked
        });

    if (context.mounted) {
      if (response["status"] == "success") {
        setState(() {
          postData.bookmarked = !postData.bookmarked!;
        });
      } else {
        showDialog(
            context: context,
            builder: (context) =>
                SystemMessage(content: "${response["data"]["message"]}"));
      }
    }

    sendingBookMark = false;
  }

  void pressAplyProcess() {}

  void sendingProcess() async {
    if (sendingMessage) return;
    if (textEditingController.text == "") return;

    sendingMessage = true;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: CommentPath.create,
        data: {
          "user_id": Network.manager.userId,
          "post_id": postData.postId,
          "content": textEditingController.text
        });

    if (context.mounted) {
      if (response["status"] == "success") {
        commentList.add(Comment.initfromData(response["data"]["comment"]));
        textEditingController.clear();
        scrollController.animateTo(0,
            duration: Duration(seconds: 1), curve: Curves.decelerate);
        setState(() {});
      } else {
        showDialog(
            context: context,
            builder: (context) =>
                SystemMessage(content: "${response["data"]["message"]}"));
      }
    }

    sendingMessage = false;
    setState(() {});
  }

  void getComment() async {
    if (gettingComment) return;
    if (noMoreComment) return;
    gettingComment = true;
    setState(() {});

    final response = await Network.manager
        .sendRequest(method: RequestMethod.post, path: CommentPath.list, data: {
      "user_id": Network.manager.userId,
      "post_id": postData.postId,
      "page": page,
      "per_page": perPage
    });

    if (context.mounted) {
      if (response["status"] == "success") {
        if (response["data"]["comments"].isEmpty) {
          noMoreComment = true;
        } else {
          for (var data in response["data"]["comments"]) {
            commentList.insert(0, Comment.initfromData(data));
          }
          page++;
        }
      } else {
        //TODO: Get Comment Failed Process
      }
    }

    gettingComment = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initialing
          ? const Center(child: CircularProgressIndicator())
          : NestedScrollView(
              controller: scrollController,
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
                        onPressed: () => pressLikedProcess(),
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
                children: [
                  detailContent(),
                  commentContent(),
                ],
              ),
            ),
    );
  }

  Widget detailContent() {
    return Column(
      children: [
        Expanded(
            child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.grey,
                  height: 200.0,
                  width: 500.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Container(
                  color: Colors.grey,
                  height: 200.0,
                  width: 500.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Container(
                  color: Colors.grey,
                  height: 200.0,
                  width: 500.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Container(
                  color: Colors.grey,
                  height: 200.0,
                  width: 500.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Container(
                  color: Colors.grey,
                  height: 200.0,
                  width: 500.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Container(
                  color: Colors.grey,
                  height: 200.0,
                  width: 500.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Container(
                  color: Colors.grey,
                  height: 200.0,
                  width: 500.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ],
            ),
          ),
        )),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () => pressBookMarkedProcess(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 245, 174, 128),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    padding: const EdgeInsets.all(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        (postData.bookmarked!
                            ? Icons.bookmark
                            : Icons.bookmark_border),
                        color: Colors.white,
                      ),
                      const Text(
                        "Bookmark",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () => pressAplyProcess(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 245, 174, 128),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    padding: const EdgeInsets.all(10.0),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        (Icons.check),
                        color: Colors.white,
                      ),
                      Text(
                        "Apply",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget commentContent() {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              for (int index = commentList.length - 1; index >= 0; index--) ...[
                CommentBlock(comment: commentList[index])
              ],
              if (noMoreComment)
                const Center(child: Text("No More Comment"))
              else if (gettingComment)
                const CircularProgressIndicator()
            ],
          ),
        )),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.deepOrange,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                cursorColor: Colors.deepOrange,
              ),
            )),
            if (sendingMessage)
              const CircularProgressIndicator()
            else
              IconButton(
                onPressed: () => sendingProcess(),
                icon: Icon(Icons.send),
                color: Colors.deepOrange,
              )
          ],
        )
      ],
    );
  }
}

class CommentBlock extends StatefulWidget {
  const CommentBlock({super.key, required this.comment});

  final Comment comment;

  @override
  State<CommentBlock> createState() => _CommentBlockState();
}

class _CommentBlockState extends State<CommentBlock> {
  late String timeAfter;
  bool sendingLike = false;
  bool deleting = false;

  @override
  void initState() {
    super.initState();

    Duration differTime =
        DateTime.now().difference(widget.comment.lastUpdateDate);
    int monthsDiff =
        (DateTime.now().year - widget.comment.lastUpdateDate.year) * 12 +
            DateTime.now().month -
            widget.comment.lastUpdateDate.month;
    if (differTime.inSeconds < 60) {
      timeAfter = "${differTime.inSeconds} seconds ago";
    } else if (differTime.inMinutes < 60) {
      timeAfter = "${differTime.inMinutes} minutes ago";
    } else if (differTime.inHours < 60) {
      timeAfter = "${differTime.inHours} hours ago";
    } else if (differTime.inDays < 7) {
      timeAfter = "${differTime.inDays} days ago";
    } else if (differTime.inDays < 30) {
      timeAfter = "${(differTime.inDays / 7).floor()} weeks ago";
    } else if (monthsDiff < 12) {
      timeAfter = "$monthsDiff months ago";
    } else {
      timeAfter = "${(monthsDiff / 12).floor()} years ago";
    }
  }

  void pressLikedProcess() async {
    if (sendingLike) return;
    sendingLike = true;

    final response = await Network.manager
        .sendRequest(method: RequestMethod.post, path: CommentPath.like, data: {
      "user_id": Network.manager.userId,
      "comment_id": widget.comment.commentsId,
      "retrieve": widget.comment.liked
    });

    if (context.mounted) {
      if (response["status"] == "success") {
        setState(() {
          widget.comment.liked = !widget.comment.liked;
        });
      } else {
        showDialog(
            context: context,
            builder: (context) =>
                SystemMessage(content: "${response["data"]["message"]}"));
      }
    }

    sendingLike = false;
  }

  void pressDeleteProcess() async {
    if (deleting) return;
    deleting = true;

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: CommentPath.delete,
        data: {
          "user_id": Network.manager.userId,
          "comment_id": widget.comment.commentsId
        });

    if (context.mounted) {
      if (response["status"] == "success") {
        widget.comment.deleted = true;
        setState(() {});
      } else{
        showDialog(context: context, builder: (context)=>SystemMessage(content: "${response["data"]["message"]}"));
      }
    }

    deleting = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: widget.comment.deleted
          ? Row(
              children: [
                Expanded(
                    child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Colors.grey),
                                right: BorderSide(color: Colors.grey),
                                bottom: BorderSide(color: Colors.grey),
                                left: BorderSide(color: Colors.grey))),
                        child: const Center(
                          child: Text(
                            "Comment Had Beend Deleted",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )))
              ],
            )
          : Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: const Icon(Icons.circle),
                ),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.comment.userNickName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            Text(widget.comment.content),
                            Text(
                              "F${widget.comment.floor} $timeAfter ${widget.comment.likes} likes No Replay haha~",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ))),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: IconButton(
                    onPressed: () => pressLikedProcess(),
                    icon: Icon(widget.comment.liked
                        ? Icons.favorite
                        : Icons.favorite_border),
                  ),
                ),
                if (widget.comment.userId == Network.manager.userId)
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: IconButton(
                      onPressed: () => pressDeleteProcess(),
                      icon: const Icon(Icons.delete),
                    ),
                  ),
              ],
            ),
    );
  }
}
