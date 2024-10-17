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

  Widget _buildStatColumn(String label, String count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
        Text(
          count,
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Profile.manager.nickname),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView( //他"整體"是要能夠滑動的，所以加一個singleScroll
        child: Column(
          children: [
            Container( //個人資訊頁面是有背景顏色的，所以將其包住
              decoration: BoxDecoration(
                color: Color(0xFFF7AF8B),
              ),
              height: 250,//固定高度為250
              child: Row( 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded( //設定他占整個row 2份比例(2:1)，包含參加過的活動數與評價，以及個人介紹(Bio，現階段還未連結Profile.manager)
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Container(
                                height: 60,
                                child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatColumn('Participated', '30'),
                                  SizedBox(width: 16),
                                  _buildStatColumn('Rating', '4.8'),
                                ],
                              ),
                              ),
                              
                              Container(
                                height: 125,
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
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(//這裡放一個"假頭貼"跟一個edit按鈕
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
                          height: 30,
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
            ),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.grid_on, color: Colors.black)),
                Tab(icon: Icon(Icons.list, color: Colors.black)),
              ],
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.grey,
            ),
            SizedBox(
              height: 500, // 给定一个固定高度，或者根据需要调整
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent('Grid View Content'),
                  _buildTabContent('List View Content'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String text) {
    return Center(
      child: Text(text, style: TextStyle(fontSize: 24)),
    );
  }
}