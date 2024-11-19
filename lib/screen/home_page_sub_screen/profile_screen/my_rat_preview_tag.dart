import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/event_card_skeleton.dart';
import 'package:spark_up/common_widget/no_more_data.dart';
import 'package:spark_up/common_widget/spark_Icon.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/my_reference_list_received.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/reference.dart';

class MyRatPreviewTag extends StatefulWidget {
  const MyRatPreviewTag({super.key, required this.userId});

  final int userId;

  @override
  State<MyRatPreviewTag> createState() => _MyRatPreviewTagState();
}

class _MyRatPreviewTagState extends State<MyRatPreviewTag>
    with AutomaticKeepAliveClientMixin {
  int page = 1, pages = 0, perPage = 20;
  bool isLoading = false, noMoreData = false;
  final ScrollController _scrollController = ScrollController();
  late List<MyReferenceListReceived> myReferenceList;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        getReferenceList();
      }
    });
    myReferenceList = [];
    getReferenceList();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future getReferenceList() async {
    if (isLoading || noMoreData) return;
    isLoading = true;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: ReferencePath.myList,
        pathMid: ["${widget.userId}"],
        data: {"page": page, "per_page": perPage});

    if (context.mounted) {
      if (response["status"] == "success") {
        myReferenceList.addAll((response["data"]["events"] as List<dynamic>)
            .map((element) => MyReferenceListReceived.initfromData(element))
            .toList());
        page = response["data"]["page"]++;
        pages = response["data"]["pages"];
        noMoreData = page > pages;
      } else {
        showDialog(
            context: context,
            builder: (context) => const SystemMessage(
                content: "Something Went Wrong\n Please Try Again Later"));
      }
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        noMoreData = false;
        page = 1;
        pages = 0;
        myReferenceList.clear();
        await getReferenceList();
        return;
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          for (var element in myReferenceList) ...[
            MyRatingCard(myReference: element)
          ],
          if (isLoading) ...[const eventCardSkeletonList()],
          if (noMoreData) ...[const NoMoreData()],
        ],
      ),
    );
  }
}

class MyRatingCard extends StatelessWidget {
  final MyReferenceListReceived myReference;

  const MyRatingCard({super.key, required this.myReference});

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                myReference.event.postTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Host: templately no data'),
              Text('Date: '),
              const SizedBox(height: 15),
              Row(
                children: [],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFB5A7),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.white, width: 2.0)),
              ),
              child: Text(
                myReference.event.postTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'hold by: template no data',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Text(
              'date: ${myReference.event.eventStartDate.year}.${myReference.event.eventStartDate.month}.${myReference.event.eventStartDate.day}-${myReference.event.eventEndDate.year}.${myReference.event.eventEndDate.month}.${myReference.event.eventEndDate.day}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    if (index < myReference.event.averageRating.floor()) {
                      return const SparkIcon(
                          icon: SparkIcons.star,
                          size: 25.0,
                          color: Color(0xffF77D43));
                    } else if (index ==
                            myReference.event.averageRating.floor() &&
                        myReference.event.averageRating % 1 != 0) {
                      return Stack(
                        children: [
                          const SparkIcon(
                              icon: SparkIcons.star,
                              size: 25.0,
                              color: Colors.white),
                          ClipRect(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: myReference.event.averageRating % 1,
                              child: const SparkIcon(
                                  icon: SparkIcons.star,
                                  size: 25.0,
                                  color: Color(0xffF77D43)),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SparkIcon(
                          icon: SparkIcons.star,
                          size: 25.0,
                          color: Colors.white);
                    }
                  }),
                ),
                const SizedBox(width: 4),
                Text(
                  myReference.event.averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
