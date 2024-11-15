import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:spark_up/common_widget/event_card_skeleton.dart';
import 'package:spark_up/common_widget/no_more_data.dart';
import 'package:spark_up/common_widget/spark_Icon.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/reference_list_received.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/reference.dart';

class TorateTag extends StatefulWidget {
  const TorateTag({super.key, required this.userId});

  final int userId;

  @override
  State<TorateTag> createState() => _TorateTagState();
}

class _TorateTagState extends State<TorateTag>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  bool noMoreData = false;
  int page = 1, pages = 0, perPage = 20;
  final ScrollController _scrollController = ScrollController();
  late List<ReferenceListReceived> referenceableList;

  @override
  void initState() {
    super.initState();

    referenceableList = [];
    getReferenceableList();
    _scrollController.addListener(
      () {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          getReferenceableList();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future getReferenceableList() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: ReferencePath.referenceableList,
        pathMid: ["${Network.manager.userId}"],
        data: {"page": page, "per_page": perPage});

    if (context.mounted) {
      if (response["status"] == "success") {
        referenceableList.addAll(
            (response["data"]["referenceable_users"] as List<dynamic>)
                .map((element) => ReferenceListReceived.initfromData(element))
                .toList());
        page++;
        pages = response["data"]["pages"];
        noMoreData = page > pages;
      } else {
        showDialog(
            context: context,
            builder: (context) => const SystemMessage(
                  content: "Something Went Wrong Pleas Try Againg Later",
                ));
      }
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: (referenceableList.isEmpty && page > 1)
              ? Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const Text(
                    "No Reference Need Submit",
                    style: TextStyle(color: Colors.black26),
                  ),
                )
              : Column(
                  children: [
                    for (var element in referenceableList) ...[
                      RateCard(referenceListReceived: element),
                    ],
                    if (noMoreData && referenceableList.isNotEmpty) ...[
                      const Center(child: NoMoreData()),
                    ],
                    if (isLoading) ...[
                      const eventCardSkeletonList(),
                    ]
                  ],
                ),
        ),
        onRefresh: () async {
          if (isLoading) return;
          referenceableList.clear();
          page = 1;
          noMoreData = false;
          await getReferenceableList();
          return;
        });
  }
}

class RateCard extends StatefulWidget {
  const RateCard({super.key, required this.referenceListReceived});

  final ReferenceListReceived referenceListReceived;

  @override
  State<RateCard> createState() => _RateCardState();
}

class _RateCardState extends State<RateCard> {
  int rate = 0;
  bool isLoading = false;
  bool rateCoplete = false;
  bool rateAlert = false;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _commentFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  Future sentRateProcess() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: ReferencePath.create,
        data: {
          "from_user_id": Network.manager.userId,
          "to_user_id": widget.referenceListReceived.userId,
          "post_id": widget.referenceListReceived.postId,
          "rating": rate,
          "content": _commentController.text
        });

    if (context.mounted) {
      if (response["status"] == "success") {
        showDialog(
            context: context,
            builder: (context) =>
                const SystemMessage(content: "Rate Successful"));
        rateCoplete = true;
      } else {
        showDialog(
            context: context,
            builder: (context) => const SystemMessage(
                content: "Something Went Wrong\nPleas Try Again Later"));
      }
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFFFFB4A8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.referenceListReceived.nickname,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Event: ${widget.referenceListReceived.postTitle}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                "Date: ${widget.referenceListReceived.eventStartDate.year}.${widget.referenceListReceived.eventStartDate.month}.${widget.referenceListReceived.eventStartDate.day}-${widget.referenceListReceived.eventEndDate.year}.${widget.referenceListReceived.eventEndDate.month}.${widget.referenceListReceived.eventEndDate.day}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 10.0),
              if (rateAlert) ...[
                Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: const Text(
                      "* At Least 1 Star Score",
                      style: TextStyle(color: Colors.red),
                    ))
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return IconButton(
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {
                        if (isLoading || rateCoplete) return;
                        setState(() {
                          rateAlert = false;
                          rate = index + 1;
                        });
                      },
                      icon: SparkIcon(
                        icon: SparkIcons.star,
                        size: 35.0,
                        color: index < rate
                            ? const Color(0xffF77D43)
                            : const Color(0xffFFFFFF).withOpacity(0.7),
                      ));
                }),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        onTapOutside: (event) => _commentFocus.unfocus(),
                        onSubmitted: (value) => _commentFocus.unfocus(),
                        focusNode: _commentFocus,
                        enabled: !(isLoading || rateCoplete),
                        controller: _commentController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'comment：',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.all(12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 25.0),
                  if (!rateCoplete && !_commentFocus.hasFocus)
                    SizedBox(
                      height: 35.0,
                      width: 100.0,
                      child: ElevatedButton(
                        onPressed: () {
                          if (rate == 0) {
                            rateAlert = true;
                            setState(() {});
                            return;
                          }
                          sentRateProcess();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF77D43),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                strokeWidth: 1.0,
                                color: Colors.black12,
                              )
                            : const Text(
                                'Rate',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                              ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
