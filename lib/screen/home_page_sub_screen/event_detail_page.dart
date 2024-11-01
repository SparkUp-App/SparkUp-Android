import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/spark_Icon.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/comment.dart';
import 'package:spark_up/data/post_view.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/applicant_path.dart';
import 'package:spark_up/network/path/comment_path.dart';
import 'package:spark_up/network/path/post_path.dart';
import 'package:intl/intl.dart';

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
  bool sendingApplicant = false;
  bool sendingMessage = false;
  bool gettingComment = false;
  bool noMoreComment = false;

  late PostView postData;
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
        postData = PostView.initfromData(response["data"]);
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

  void pressAplyProcess() async {
    if (sendingApplicant) return;
    if (postData.applicationStatus == 1 || postData.applicationStatus == 2) return;
    sendingApplicant = true;

    Map response;
    bool isCreating = postData.applicationStatus == null;
    
    if (isCreating) {
      debugPrint("Create");
      response = await Network.manager.sendRequest(
          method: RequestMethod.post,
          path: ApplicantPath.create,
          data: {
            "user_id": Network.manager.userId,
            "post_id": postData.postId,
            "attributes": {}
          });
    } else {
      debugPrint("Delete");
      response = await Network.manager.sendRequest(
          method: RequestMethod.delete,
          path: ApplicantPath.delete,
          data: {
            "user_id": Network.manager.userId,
            "post_id": postData.postId
          });
    }

    if (context.mounted) {
      if (response["status"] == "success") {
        showDialog(
            context: context,
            builder: (context) => SystemMessage(
                content: isCreating
                    ? "Send Application Request Successful"
                    : "Cancel Application Successful"));
        
        // 更新狀態：如果是創建則設為 0，如果是取消則設為 null
        postData.applicationStatus = isCreating ? 0 : null;
      } else {
        showDialog(
            context: context,
            builder: (context) => SystemMessage(
                content: isCreating
                    ? "Send Application Request Failed\n (Please Try Later)"
                    : "Cancel Application Failed\n (Please Try Later)"));
      }
    }

    setState(() {});
    sendingApplicant = false;
  }

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
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () => pressLikedProcess(),
                        icon: Icon(
                          postData.liked!
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: const Color.fromARGB(255, 233, 113, 153),
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                  expandedHeight: 220.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40,),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width - 80,
                            ),
                            child: Text(
                              postData.title,
                              style: const TextStyle(fontSize: 26.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
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
                          SizedBox(width: 10),
              
                                const SparkIcon(
                                  icon: SparkIcons.heart,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${postData.likes}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                const SparkIcon(
                                  icon: SparkIcons.comment,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${postData.comments}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
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
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Date and time
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.blue[700], size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${DateFormat('M/d HH:mm').format(postData.eventStartDate)} - ${DateFormat('M/d HH:mm').format(postData.eventEndDate)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // People required
                      Row(
                        children: [
                          Icon(Icons.group, color: Colors.green[700], size: 20),
                          SizedBox(width: 12),
                          Text(
                            "${postData.numberOfPeopleRequired} people required",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Location
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.red[700], size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              postData.location,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Additional Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                // Attributes section
if (postData.attributes.isNotEmpty) ...[
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (int i = 0; i < postData.attributes.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //ElevatedButton(onPressed: ()=>print(postData.attributes), child: Text('A')), for testing 
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${postData.attributes.keys.elementAt(i)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (postData.attributes.values.elementAt(i) is String)
                  Text(
                    "${postData.attributes.values.elementAt(i)}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  )
                else if (postData.attributes.values.elementAt(i) is List)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var item in (postData.attributes.values.elementAt(i) as List))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.toString(),  // 將任何類型轉換為字串
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      SizedBox(height: 20),
    ],
  ),
],
                const SizedBox(height:20),
            const Text(
              "Other Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                postData.content.isEmpty? "(The initiator did not mention)": postData.content,
                style: TextStyle(
                  fontSize: 16,
                  color:postData.content.isEmpty? Colors.grey[400]:Colors.grey[800],
                  height: 1.5,
                ),
              ),
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
                        (postData.bookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border),
                        color: Colors.white,
                      ),
                      Text(
                        (postData.bookmarked ? "Unbookmark" : "Bookmark"),
                        style: const TextStyle(color: Colors.white),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        (Icons.check),
                        color: Colors.white,
                      ),
                      Text(
                        (switch (postData.applicationStatus) {
                          0 => 'Cancel Apply',
                          1 => 'Reject',
                          2 => 'Approved',
                          _ => 'Apply'
                        }),
                        style: const TextStyle(color: Colors.white),
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
      } else {
        showDialog(
            context: context,
            builder: (context) =>
                SystemMessage(content: "${response["data"]["message"]}"));
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
