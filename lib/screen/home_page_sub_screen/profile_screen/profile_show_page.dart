import 'package:flutter/material.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/user_path.dart';
import 'package:spark_up/route.dart';
import 'package:spark_up/data/profile.dart';
import 'package:spark_up/screen/home_page_sub_screen/profile_screen/hold_event_tab.dart';
import 'package:spark_up/screen/home_page_sub_screen/profile_screen/profile_tab.dart';

class ProfileShowPage extends StatefulWidget {
  const ProfileShowPage(
      {super.key, required this.userId, required this.editable});

  final int userId;
  final bool editable;

  @override
  State<ProfileShowPage> createState() => _ProfileShowPageState();
}

class _ProfileShowPageState extends State<ProfileShowPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Profile profile;
  late double rating;
  late int participated;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget _buildStatColumn(String label, String count, IconData stateIcon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Icon(
              stateIcon,
              color: Colors.white,
              size: 40,
            ),
            Text(
              count,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget profileHeaderWidget(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7AF8B),
      ),
      height: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn('Participated',
                                participated.toString(), Icons.flag),
                            const SizedBox(width: 16),
                            _buildStatColumn('Rating',
                                rating.toStringAsFixed(1), Icons.star),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 95,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            profile.bio,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: Profile
                                            .manager.interestTypes.length,
                                        itemBuilder: (context, index) {
                                          final tag = Profile
                                              .manager.interestTypes[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Chip(
                                              label: Text(
                                                '#$tag',
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                              backgroundColor: Colors.grey[200],
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.editable) ...[
                  SizedBox(
                    width: 130,
                    height: 25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF16743),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, RouteMap.editProfile),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Network.manager.sendRequest(
            method: RequestMethod.get,
            path: UserPath.view,
            pathMid: ["${Network.manager.userId}"]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!["data"] == null) {
              return const Center(child: Text("Doesn't Get Data"));
            }

            //Data Initial
            profile = Profile.initfromData(snapshot.data!["data"]["profile"]);
            rating = snapshot.data!["data"]["rating"];
            participated = snapshot.data!["data"]["participated"];

            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(57.0),
                child: Container(
                  color: const Color(0xFFF7AF8B),
                  child: Column(
                    children: [
                      AppBar(
                        automaticallyImplyLeading: false,
                        title: Text(
                          profile.nickname,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        actions: [
                          IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RouteMap.editProfile);
                            },
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              body: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            profileHeaderWidget(context),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: Column(
                    children: <Widget>[
                      Material(
                        color: Colors.white,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey[400],
                          indicatorWeight: 2,
                          indicatorColor: const Color(0xFFF7AF8B),
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.grey.withOpacity(0.1);
                              }
                              return null;
                            },
                          ),
                          tabs: const [
                            Tab(
                              text: "Event",
                            ),
                            Tab(
                              text: "Profile",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            HoldEventTab(userId: widget.userId),
                            ProfileTab(profile: profile),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("Error"),
            );
          }
        });
  }

  Widget _buildTabContent(String text) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('$text Item $index'),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
