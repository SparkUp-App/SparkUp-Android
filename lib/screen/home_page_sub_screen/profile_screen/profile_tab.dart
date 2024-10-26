import 'package:flutter/material.dart';
import 'package:spark_up/data/profile.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F2EF),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Personal Profile",
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 16),
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

              buildProfileList("Skills", profile.skills),
              buildProfileList("Personalities", profile.personalities),
              buildProfileList("Languages", profile.languages),
              buildProfileList("Interests", profile.interestTypes),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileItem(String title, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
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
      ),
    );
  }

  Widget buildProfileList(String title, List<String> items) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
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
        ));
  }
}
