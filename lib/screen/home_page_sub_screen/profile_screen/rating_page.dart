import 'package:flutter/material.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/screen/home_page_sub_screen/profile_screen/my_rat_preview_tag.dart';
import 'package:spark_up/screen/home_page_sub_screen/profile_screen/to_rate_tag.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key, required this.userId});

  final int userId;

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool selfRating;

  @override
  void initState() {
    super.initState();
    selfRating = Network.manager.userId == widget.userId;
    _tabController = TabController(length: selfRating ? 2 : 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
          centerTitle: true,
          title: const Text(
            "Rating",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFF7AF8B),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelStyle: const TextStyle(fontSize: 14.0),
                labelColor: Colors.black,
                unselectedLabelColor: const Color(0xFF827C79),
                indicatorColor: const Color(0xFFF5A278),
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: selfRating
                    ? const [
                        Tab(text: 'To Rate'),
                        Tab(text: 'My Preview'),
                      ]
                    : const [
                        Tab(text: 'My Preview'),
                      ],
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: selfRating
                      ? [
                          TorateTag(
                            userId: widget.userId,
                          ),
                          MyRatPreviewTag(
                            userId: widget.userId,
                          )
                        ]
                      : [
                          MyRatPreviewTag(
                            userId: widget.userId,
                          )
                        ]),
            )
          ],
        ));
  }
}
