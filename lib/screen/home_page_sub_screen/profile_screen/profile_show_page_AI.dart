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
  
  Widget _buildStatColumn(String label, String count, IconData stateIcon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                stateIcon,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(width: 8),
              Text(
                count,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFF7AF8B),
            Color(0xFFF16743),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Row
                      Row(
                        children: [
                          Expanded(child: _buildStatColumn('Participated', '30', Icons.flag)),
                          SizedBox(width: 12),
                          Expanded(child: _buildStatColumn('Rating', '4.8', Icons.star)),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Bio Section
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          Profile.manager.bio,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width:20,),
                Container(
                  width: 105,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 105,
                        height: 32,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFFF16743),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => Navigator.pushNamed(context, RouteMap.editProfile),
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
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
          // Interest Tags Section
          Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Profile.manager.interestTypes.length,
              itemBuilder: (context, index) {
                final tag = Profile.manager.interestTypes[index];
                return Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFF16743),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
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
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              expandedHeight: 60,
              floating: true,
              pinned: true,
              backgroundColor: Color(0xFFF7AF8B),
              elevation: 0,
              title: Text(
                Profile.manager.nickname,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pushNamed(context, RouteMap.editProfile),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: profileHeaderWidget(context),
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Color(0xFFF16743),
                unselectedLabelColor: Colors.grey[400],
                indicatorWeight: 3,
                indicatorColor: Color(0xFFF16743),
                tabs: [
                  Tab(icon: Icon(Icons.grid_on_sharp)),
                  Tab(icon: Icon(Icons.bookmark_border)),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGridContent(),
                  _buildGridContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridContent() {
    return GridView.builder(
      padding: EdgeInsets.all(4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Item $index',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        );
      },
    );
  }
}