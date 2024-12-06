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
        page = response["data"]["page"];
        page++;
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
      },
      child: myReferenceList.isNotEmpty || isLoading
          ? ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: myReferenceList.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < myReferenceList.length) {
                  return MyRatingCard(myReference: myReferenceList[index]);
                } else {
                  return const eventCardSkeletonList();
                }
              },
            )
          : _buildEmptyState(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/No_Event_space.png',
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.35,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            const Text(
              "You haven’t get any rate from others.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 252, 164, 140),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title with gradient border bottom
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  myReference.event.postTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Info Cards
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.person, 'Host: templately no data'),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.calendar_today,
                        'Date: ${_formatDate(myReference.event.eventStartDate)} - ${_formatDate(myReference.event.eventEndDate)}'),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                        Icons.category, 'Type: ${myReference.event.type}'),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.location_on,
                        'Location: ${myReference.event.location}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Rating Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.orange[400],
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      myReference.event.averageRating.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${myReference.event.ratingCount} ratings)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFBAA6),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Color.fromARGB(255, 241, 152, 111).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  myReference.event.postTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'hold by: template no data',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'date: ${_formatDate(myReference.event.eventStartDate)}-${_formatDate(myReference.event.eventEndDate)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 252, 164, 140),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        if (index < myReference.event.averageRating.floor()) {
                          return const SparkIcon(
                            icon: SparkIcons.star,
                            size: 25.0,
                            color: Color(0xFFFFF3E0),
                          );
                        } else if (index ==
                                myReference.event.averageRating.floor() &&
                            myReference.event.averageRating % 1 != 0) {
                          return Stack(
                            children: [
                              const SparkIcon(
                                icon: SparkIcons.star,
                                size: 25.0,
                                color: Colors.white24,
                              ),
                              ClipRect(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  widthFactor:
                                      myReference.event.averageRating % 1,
                                  child: const SparkIcon(
                                    icon: SparkIcons.star,
                                    size: 25.0,
                                    color: Color(0xFFFFF3E0),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const SparkIcon(
                            icon: SparkIcons.star,
                            size: 25.0,
                            color: Colors.white24,
                          );
                        }
                      }),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        myReference.event.averageRating.toStringAsFixed(1),
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 126, 90),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
