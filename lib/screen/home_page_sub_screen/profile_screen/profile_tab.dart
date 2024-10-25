import 'package:flutter/material.dart';
import 'package:spark_up/data/profile.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Divider(
            thickness: 2,
            color: Colors.orange,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF7F2EF), // 浅色背景
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildProfileItem("User Name", profile.nickname),
                  buildProfileItem("Phone", profile.phone),
                  buildProfileItem("Gender", profile.gneder.name),
                  buildProfileItem("Date of Birth", profile.dob),
                  buildProfileItem("Bio", profile.bio),
                  buildProfileItem("Current Location", profile.currentLocation),
                  buildProfileItem("Hometown", profile.hoemTown),
                  buildProfileItem("College", profile.college),
                  buildProfileItem("Job Title", profile.jobTitle),
                  buildProfileItem("Education Level", profile.educationLevel),
                  buildProfileItem("MBTI", profile.mbti),
                  buildProfileItem("Constellation", profile.constellation),
                  buildProfileItem("Blood Type", profile.bloodType),
                  buildProfileItem("Religion", profile.religion),
                  buildProfileItem("Sexuality", profile.sexuality),
                  buildProfileItem("Ethnicity", profile.ethnicity),
                  buildProfileItem("Diet", profile.diet),
                  buildProfileItem("Smoke", profile.smoke.name),
                  buildProfileItem("Drinking", profile.drinking.name),
                  buildProfileItem("Marijuana", profile.marijuana.name),
                  buildProfileItem("Drugs", profile.drugs.name),
                  
                  const SizedBox(height: 24),
                  Text(
                    "Skills and Interests",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  // Lists of Interests
                  buildProfileList("Skills", profile.skills),
                  buildProfileList("Personalities", profile.personalities),
                  buildProfileList("Languages", profile.languages),
                  buildProfileList("Interests", profile.interestTypes),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Profile 页处于激活状态
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // 每个单独的个人资料项目
  Widget buildProfileItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // 展示技能、兴趣等列表项目
  Widget buildProfileList(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: items
              .map((item) => Chip(
                    label: Text(item),
                    backgroundColor: Colors.blue.shade100,
                    labelStyle: const TextStyle(fontSize: 14),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}