import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/comment.dart';
import 'package:spark_up/data/post_view.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/applicant_path.dart';
import 'package:spark_up/network/path/comment_path.dart';
import 'package:spark_up/network/path/post_path.dart';
import 'package:intl/intl.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/preview_detail_data.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/preview_detail_data_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:math';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:toasty_box/toast_enums.dart';

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

  String _generateRandomSpaces(int length) {
    return ' ' * length; // 生成指定長度的空白字符
  }
  final Random random = Random();

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
          postData.liked = !postData.liked;
          if(postData.liked == true) 
          ToastService.showSuccessToast(
            context,
            length: ToastLength.medium,
            expandedHeight: 100,
            message: "This event gets your like!"
          );
          else if(postData.liked == false )
          ToastService.showSuccessToast(
            context,
            length: ToastLength.medium,
            expandedHeight: 100,
            message: "You take back your like!"
          );
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
          postData.bookmarked = !postData.bookmarked;
          if(postData.bookmarked == true) 
          ToastService.showSuccessToast(
            context,
            length: ToastLength.medium,
            expandedHeight: 100,
            message: "You have bookmark this event!"
          );
          else if(postData.bookmarked == false )
          ToastService.showSuccessToast(
            context,
            length: ToastLength.medium,
            expandedHeight: 100,
            message: "You have unbookmark this event!"
          );
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
  Widget SkeletonLoader(){
    final labelSpaces = _generateRandomSpaces(random.nextInt(15) + 10); // 隨機生成5到15個空白字符
    final titleSpaces = _generateRandomSpaces(random.nextInt(50) + 40); // 隨機生成10到40個空白字符
    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: Colors.white12,
        highlightColor: Colors.white24,
        duration: Duration(seconds: 1),
      ),
      child:
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Skeleton.leaf(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFff6b6b),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  labelSpaces, // 使用隨機生成的空白字符
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 6,),
            Skeleton.leaf(
              child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  titleSpaces, // 使用隨機生成的空白字符
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左側資訊
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton.leaf(
                      child:Container(
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Hold By:AAAAA", // 使用隨機生成的空白字符
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Skeleton.leaf(
                      child:Container(
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Posted:2024/01/10", // 使用隨機生成的空白字符
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Skeleton.leaf(
                  child:Container(
                    height: 25,
                    width:135,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Hold By:AAAAA", // 使用隨機生成的空白字符
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color.fromARGB(255, 245, 174, 128),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
              actions: initialing
                  ? []
                  : [
                IconButton(
                  onPressed: () => pressLikedProcess(),
                  icon: Icon(
                    postData.liked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: const Color.fromARGB(255, 233, 113, 153),
                    size: 24.0,
                  ),
                ),
                IconButton(
                  onPressed: pressBookMarkedProcess,
                  icon: Icon(
                    postData.bookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                  ),
                  color: Colors.white,
                  
                ),
              ],

              expandedHeight: 220.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: const Color.fromARGB(255, 245, 174, 128),
                  padding: const EdgeInsets.fromLTRB(30, 90, 30, 30),
                  child:initialing? SkeletonLoader(): Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "#${postData.type}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        postData.title,
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 左側資訊
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Hold by: ',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    postData.nickname,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Posted: ${DateFormat('yyyy/MM/dd').format(postData.eventStartDate)}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          // 右側統計
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${postData.likes}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${postData.comments}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${postData.applicants ?? 0}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: "Overview"),
                  Tab(text: "Comments"),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: !initialing
              ? [
                  detailContent(),
                  commentContent(),
                ]
              : [
                  detailContentSkeleton(),
                  detailContentSkeleton(),
                ],
        ),
      ),
    );
  }
Widget detailContentSkeleton() {
    return Column(
      children: [
        Expanded(
            child: SizedBox(
              child: SingleChildScrollView(
                child: InfoPreviewCardSkeleton(),
              ),
            )),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        if(!initialing) Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  child: Visibility(
                    visible: (postData.postId != Network.manager.userId), // 要求你給我他這篇文的api
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        (Icons.check),
                        color: Colors.white,
                      ),
                      Text(
                         'Apply',
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  )
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
  Widget detailContent() {
    return Column(
      children: [
        Expanded(
            child: SizedBox(
              child: SingleChildScrollView(
                child: InfoPreviewCard(
                  title: postData.title,
                  startDate: postData.eventStartDate,
                  endDate: postData.eventEndDate,
                  peopleRequired: postData.numberOfPeopleRequired,
                  location: postData.location,
                  attributes: postData.attributes,
                  content: postData.content,
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
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0), // 調整為更圓潤
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: "  Write a comment...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none, // 移除邊框
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0), // 調整輸入框高度
                  ),
                  cursorColor: Colors.deepOrange,
                ),
              ),
              sendingMessage
                  ? const CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.deepOrange,
                    )
                  : IconButton(
                      onPressed: () => sendingProcess(),
                      icon: const Icon(Icons.send),
                      color: Colors.deepOrange,
                    ),
            ],
          ),
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
  bool _isLongPressed = false;

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
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                padding: const EdgeInsets.all(10),
                child: const Center(
                  child: Text(
                    "Comment Has Been Deleted",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        )
      : GestureDetector(
          onLongPress: widget.comment.userId == Network.manager.userId 
            ? () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('刪除評論'),
                    content: const Text('您確定要刪除此評論嗎？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          pressDeleteProcess();
                        },
                        child: const Text('確定'),
                      ),
                    ],
                  ),
                );
              }
            : null,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: const Icon(Icons.circle, color: Colors.black),
                                ),
                                Text(
                                  widget.comment.userNickName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 4),
                            Padding(
                              padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                              child: Text(
                                widget.comment.content,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                              child: Text(
                                "F${widget.comment.floor} $timeAfter ${widget.comment.likes} likes",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: IconButton(
                          onPressed: () => pressLikedProcess(),
                          icon: Icon(
                            widget.comment.liked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.comment.liked
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
);
  }
}


