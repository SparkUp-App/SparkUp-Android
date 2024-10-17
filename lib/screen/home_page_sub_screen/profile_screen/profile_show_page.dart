import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spark_up/route.dart';
import 'package:spark_up/data/profile.dart';

class ProfileShowPage extends StatefulWidget {
  const ProfileShowPage({super.key});

  @override
  State<ProfileShowPage> createState() => _ProfileShowPageState();
}

class _ProfileShowPageState extends State<ProfileShowPage> with TickerProviderStateMixin {
  late TabController _tabController;

  Widget _buildStatColumn(String label, String count,IconData stateIcon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
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
              style: TextStyle(
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

  Widget profileHeaderWidget(BuildContext context) { //header 設計直接複製貼上
    return Container(
      decoration: BoxDecoration(
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
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn('Participated', '30',Icons.flag),
                            SizedBox(width: 16),
                            _buildStatColumn('Rating', '4.8',Icons.star),
                          ],
                        ),
                      ),
                      Container(
                        height: 95,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            Profile.manager.bio,
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 40, // 調整整體高度以縮小
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: Profile.manager.interestTypes.length,
                                        itemBuilder: (context, index) {
                                          final tag = Profile.manager.interestTypes[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2), // 減少間距
                                            child: Chip(
                                              label: Text(
                                                '#$tag',
                                                style: TextStyle(
                                                  fontSize: 10, // 調整標籤字體大小以縮小
                                                ),
                                              ),
                                              backgroundColor: Colors.grey[200],
                                              padding: EdgeInsets.symmetric(horizontal: 2), // 調整 Chip 的內邊距
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),// 調整圓角半徑
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
                SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 130,
                  height: 25,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF16743),
                    ),
                    onPressed: () => Navigator.pushNamed(context, RouteMap.editProfile),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(57.0), // 調整AppBar的高度
        child: Container(
          color: Color(0xFFF7AF8B), // 與Container相同的顏色
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  Profile.manager.nickname,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ), // 縮小字體大小
                ),
                backgroundColor: Colors.transparent, // 透明背景
                foregroundColor: Colors.black,
                elevation: 0, // 去掉陰影
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, RouteMap.editProfile);
                    },

                  ),
                ],
              ),
              Container(
                height: 1, // 白線的高度
                color: Colors.white, // 白色
              ),
            ],
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) { //設定header
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
                  indicatorWeight: 1,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.grid_on_sharp,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.grid_on_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTabContent('Grid'),
                    _buildTabContent('IGTV'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}