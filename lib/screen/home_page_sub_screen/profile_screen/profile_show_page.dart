import 'package:flutter/material.dart';
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
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          count,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        body: Column(
            children:[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF16743),
                ),
                height: 250,
                child: Row(//個人資訊:一個超大Row，分兩塊，一塊給基本資料顯示，一塊給"假頭貼"跟edit按鈕
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(//根據擁有的空間去做
                    flex: 2,//做一個2:1
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatColumn('Participated', '30'),
                                  SizedBox(width: 16),
                                  _buildStatColumn('Rating', '4.8'),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Container( //不用textfield，直接用一個container顯示就好，爽
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.75,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:
                                Text(
                                  'Passionate about creating user-friendly and efficient mobile applications.',
                                  style: TextStyle(height: 1.4),
                                ),
                              ),
                              SizedBox(height: 16),
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
                        SizedBox(height: 20,),
                        CircleAvatar(
                          radius: 50,
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: 110,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, RouteMap.editProfile),
                            child: Text("Edit"),
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
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTabContent('Grid View Content'),
                    _buildTabContent('List View Content'),
                  ],
                ),
              ),
            ]
        )
    );
  }

  Widget _buildTabContent(String text) {
    return Center(
      child: Text(text, style: TextStyle(fontSize: 24)),
    );
  }
}