import 'package:flutter/material.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/user_path.dart';
import 'package:spark_up/route.dart';
import 'package:spark_up/data/profile.dart';
import 'package:spark_up/screen/home_page_sub_screen/profile_screen/hold_event_tab.dart';
import 'package:spark_up/screen/home_page_sub_screen/profile_screen/profile_tab.dart';
import 'package:spark_up/screen/logout_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
              size: 30,
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
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn('Participated',
                                participated.toString(), Icons.flag),
                            Container(
                              width: 2,
                              height: 40,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            _buildStatColumn('Rating',
                                rating.toStringAsFixed(1), Icons.star),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * 0.75,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          profile.bio,
                          style: const TextStyle(
                            color: Colors.white,
                            height: 1.3,
                          ),
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
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 45,
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.editable) ...[
                  SizedBox(
                    width: 130,
                    height: 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, RouteMap.editProfile),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Color(0xFFF16743),
                          fontWeight: FontWeight.bold,
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

  Widget _buildSkeletonHeader() {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: Colors.white12,
        highlightColor: Colors.white24,
        duration: Duration(seconds: 1),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF7AF8B),
        ),
        height: 200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Skeleton.leaf(
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatColumn('Participated', '0', Icons.flag),
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                _buildStatColumn('Rating', '0.0', Icons.star),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Skeleton.leaf(
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.75,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Loading...',
                              style: TextStyle(
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
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
                  Skeleton.leaf(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.editable)
                    Skeleton.leaf(
                      child: SizedBox(
                        width: 130,
                        height: 32,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: null,
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Color(0xFFF16743),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
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
                          "Loading...",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: snapshot.connectionState == ConnectionState.waiting ? Colors.white54:Colors.white,
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
                              Navigator.of(context).pushNamed(RouteMap.logoutPage);
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
                        delegate: SliverChildListDelegate([
                          Skeletonizer(
                            enabled: true,
                            effect: const ShimmerEffect(
                              baseColor: Colors.white12,
                              highlightColor: Colors.white24,
                              duration: Duration(seconds: 1),
                            ),
                            child: Column(
                              children: [
                                _buildSkeletonHeader(),
                                Container(
                                  height: 50,
                                  color: const Color(0xFFF7AF8B),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    itemCount: Profile.manager.interestTypes.length,
                                    itemBuilder: (context, index) {
                                      final tag = Profile.manager.interestTypes[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Skeleton.leaf(child:Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: const Color(0xFFF16743),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            '#$tag',
                                            style: const TextStyle(
                                              color: Color(0xFFF16743),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
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
                    ],
                  ),
                ),
              ),
            );
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
                              Navigator.of(context).pushNamed(RouteMap.logoutPage);
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
                        delegate: SliverChildListDelegate([
                          profileHeaderWidget(context),
                          Container(
                            height: 50,
                            color: Color(0xFFF7AF8B),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              itemCount: Profile.manager.interestTypes.length,
                              itemBuilder: (context, index) {
                                final tag = Profile.manager.interestTypes[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFFF16743),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '#$tag',
                                      style: const TextStyle(
                                        color: Color(0xFFF16743),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
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
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
