import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/empty_view.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/user_path.dart';
import 'package:spark_up/route.dart';
import 'package:spark_up/data/profile.dart';
import 'package:spark_up/screen/home_page_sub_screen/profile_screen/hold_event_tab.dart';
import 'package:spark_up/screen/home_page_sub_screen/profile_screen/profile_tab.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';

class ProfileShowPage extends StatefulWidget {
  const ProfileShowPage(
      {super.key,
      required this.userId,
      required this.editable,
      this.fromHomePage = false});

  final int userId;
  final bool editable;
  final bool fromHomePage;

  @override
  State<ProfileShowPage> createState() => _ProfileShowPageState();
}

class _ProfileShowPageState extends State<ProfileShowPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Profile profile;
  late double rating;
  late int participated;
  late int level;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget _buildStatColumn(String label, String count, IconData stateIcon) {
    return InkWell(
      onTap: () {
        switch (label) {
          case "Participated":
            Navigator.of(context)
                .pushNamed(RouteMap.participatedPage, arguments: widget.userId);
            break;
          case "Rating":
            Navigator.of(context)
                .pushNamed(RouteMap.ratingPage, arguments: widget.userId);
            break;
        }
      },
      splashColor: Colors.grey,
      highlightColor: Colors.grey,
      child: Column(
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
      ),
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
                          color: Colors.transparent,
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteMap.levelPage);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        switch (level) {
                          0 => 'assets/member/Nebulas.png',
                          1 => 'assets/member/Proto Star.png',
                          2 => 'asssets/member/Main Sequence.png',
                          3 => 'assets/member/Red Giant.png',
                          4 => 'assets/member/Supernova.png',
                          int() => 'assets/member/Nebulas.png',
                        },
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.editable) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 130,
                    height: 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        final update = await Navigator.pushNamed(
                            context, RouteMap.editProfile,
                            arguments: profile);
                        if (update == true) setState(() {});
                      },
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Color(0xFFF16743),
                            fontWeight: FontWeight.bold,
                          ),
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
                                _buildStatColumn(
                                    'Participated', '0', Icons.flag),
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
                      child: ClipOval(
                        child: Image.asset(
                          'assets/member/Nebulas.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
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
            pathMid: ["${widget.userId}"]),
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
                        leading: widget.fromHomePage
                            ? null
                            : IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                )),
                        automaticallyImplyLeading: false,
                        title: Text(
                          "Loading...",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? Colors.white54
                                : Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        actions: widget.fromHomePage
                            ? [
                                IconButton(
                                  icon: const Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(RouteMap.logoutPage);
                                  },
                                ),
                              ]
                            : null,
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * 0.9,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    itemCount: ['Loading...'].length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Skeleton.leaf(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: const Color(0xFFF16743),
                                                width: 1,
                                              ),
                                            ),
                                            child: const Text(
                                              '#Loading...',
                                              style: TextStyle(
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
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 16,
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
              backgroundColor: const Color(0xFFF7F2EF),
            );
          } else if (snapshot.hasError) {
            //other user view profile
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!widget.editable) {
                Navigator.pop(context);
                ToastService.showErrorToast(context,
                    length: ToastLength.medium,
                    expandedHeight: 100,
                    message:
                        "Loading profile failed, please try again later.(Error: Local error)");
              } else {
                showDialog(
                    context: context,
                    builder: (context) => const SystemMessage(
                        title: "Local error",
                        content:
                            "An unexpected local error occured please try again later."));
              }
            });
            return profileLoadFailedScreen(snapshot.data);
          } else if (snapshot.hasData) {
            if (!widget.editable && snapshot.data!["status"] != "success") {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (snapshot.data!["status"] == "error") {
                  switch (snapshot.data!["data"]["message"]) {
                    case "Timeout Error":
                      ToastService.showErrorToast(context,
                          length: ToastLength.medium,
                          expandedHeight: 100,
                          message:
                              "Loading profile failed, please try again later. (Error: Timeout error)");
                      break;
                    case "Connection Error":
                      ToastService.showErrorToast(context,
                          length: ToastLength.medium,
                          expandedHeight: 100,
                          message:
                              "Loading profile failed, please try again later. (Error: Connection error)");
                      break;
                    default:
                      ToastService.showErrorToast(context,
                          length: ToastLength.medium,
                          expandedHeight: 100,
                          message:
                              "Loading profile failed, please try again later. (Error: Local error)");
                      break;
                  }
                } else if (snapshot.data!["status"] == "faild") {
                  switch (snapshot.data!["status_code"]) {
                    case 404:
                      ToastService.showErrorToast(context,
                          length: ToastLength.medium,
                          expandedHeight: 100,
                          message:
                              "Loading profile failed, please try again later. (Error: User not found)");
                      break;
                    default:
                      ToastService.showErrorToast(context,
                          length: ToastLength.medium,
                          expandedHeight: 100,
                          message:
                              "Loading profile failed, please try again later. (Error: Server error)");
                      break;
                  }
                }

                Navigator.pop(context);
              });
              return profileLoadFailedScreen(snapshot.data);
            } else if (snapshot.data!["status"] != "success") {
              if (snapshot.data!["status"] == "error") {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  switch (snapshot.data!["data"]["message"]) {
                    case "Timeout Error":
                      showDialog(
                          context: context,
                          builder: (context) => const SystemMessage(
                              title: "Timout error",
                              content:
                                  "The response time is too long, please check the connection and tyr again later."));
                      break;
                    case "Connection Error":
                      showDialog(
                          context: context,
                          builder: (context) => const SystemMessage(
                              title: "Connection error",
                              content:
                                  "The connection is unstable, please check the connection and try again later."));
                      break;
                    default:
                      showDialog(
                          context: context,
                          builder: (context) => const SystemMessage(
                              title: "Local error",
                              content:
                                  "An unexpected local error occured, please contact us or try again later."));
                      break;
                  }
                });
              } else if (snapshot.data!["status"] == "faild") {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  switch (snapshot.data!["status_code"]) {
                    case 404:
                      showDialog(
                          context: context,
                          builder: (context) => const SystemMessage(
                                title: "User not found",
                                content: "The user had no longer exist.",
                              ));
                      break;
                    default:
                      showDialog(
                          context: context,
                          builder: (context) => const SystemMessage(
                              content:
                                  "An unexpected server error occured, please contact us or try again later."));
                      break;
                  }
                });
              }
              return profileLoadFailedScreen(snapshot.data!);
            }

            //Data Initial
            profile = Profile.initfromData(snapshot.data!["data"]["profile"]);
            rating = snapshot.data!["data"]["rating"];
            participated = snapshot.data!["data"]["participated"];
            level = snapshot.data!["data"]["level"] ?? 0;

            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(57.0),
                child: Container(
                  color: const Color(0xFFF7AF8B),
                  child: Column(
                    children: [
                      AppBar(
                        leading: widget.fromHomePage
                            ? null
                            : IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                )),
                        automaticallyImplyLeading: false,
                        title: Text(
                          profile.nickname,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        actions: widget.fromHomePage
                            ? [
                                IconButton(
                                  icon: const Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(RouteMap.logoutPage);
                                  },
                                ),
                              ]
                            : null,
                      ),
                      Center(
                          child: Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * 0.95,
                        color: Colors.white,
                      )),
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
                            color: const Color(0xFFF7AF8B),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              itemCount: profile.interestTypes.length,
                              itemBuilder: (context, index) {
                                final tag = profile.interestTypes[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
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
            //other user view profile
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!widget.editable) {
                ToastService.showErrorToast(context,
                    length: ToastLength.medium,
                    expandedHeight: 100,
                    message:
                        "Loading profile failed, please try again later.(Error: Local error)");
                Navigator.pop(context);
              } else {
                showDialog(
                    context: context,
                    builder: (context) => const SystemMessage(
                        title: "Local error",
                        content:
                            "An unexpected local error occured, please contact us or try again later."));
              }
            });
            return profileLoadFailedScreen(snapshot.data);
          }
        });
  }

  Widget profileLoadFailedScreen(Map? response) {
    return Scaffold(
        appBar: AppBar(
          leading: widget.fromHomePage
              ? null
              : IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
          title: const Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFFF7AF8B),
          elevation: 0,
          actions: widget.fromHomePage
              ? [
                  IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(RouteMap.logoutPage);
                    },
                  ),
                ]
              : null,
        ),
        backgroundColor: const Color(0xFFF7F2EF),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyView(
                content:
                    "Profile load failed, presse the button below to reload the page."),
            IconButton(
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh),
            )
          ],
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
