import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/spark_Icon.dart';
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
              buildProfileItem(SparkIcons.user, "User Name", profile.nickname),
              buildProfileItem(SparkIcons.phone, "Phone", profile.phone),
              buildProfileItem(
                  SparkIcons.gender, "Gender", profile.gneder.name),
              buildProfileItem(
                  SparkIcons.calendar, "Date of Birth", profile.dob),
              buildProfileList(
                  SparkIcons.language, "Languages", profile.languages),
              const SizedBox(
                height: 24.0,
              ),
              buildProfileItem(SparkIcons.location, "Current Location",
                  profile.currentLocation),
              buildProfileItem(
                  SparkIcons.hometown, "Hometown", profile.hoemTown),
              buildProfileItem(SparkIcons.school, "College", profile.college),
              buildProfileItem(SparkIcons.work, "Job Title", profile.jobTitle),
              buildProfileItem(
                  SparkIcons.blood, "Blood Type", profile.bloodType),
              buildProfileItem(SparkIcons.education, "Education Level",
                  profile.educationLevel),
              buildProfileItem(
                  SparkIcons.zodiacSign, "Zodiac", profile.constellation),
              buildProfileItem(SparkIcons.smile, "MBTI", profile.mbti),
              buildProfileItem(
                  SparkIcons.religion, "Religion", profile.religion),
              // buildProfileItem("Marijuana", profile.marijuana.name),
              // buildProfileItem("Drugs", profile.drugs.name),
              buildProfileItem(
                  SparkIcons.users, "Ethnicity", profile.ethnicity),
              buildProfileItem(SparkIcons.eat, "Diet", profile.diet),
              buildProfileItem(
                  SparkIcons.alcohol, "Alcohol", profile.drinking.label),
              buildProfileItem(
                  SparkIcons.smoking, "Smoke", profile.smoke.label),
              buildProfileItem(
                  SparkIcons.sexuality, "Sexuality", profile.sexuality),
              const SizedBox(height: 16),
              buildProfileList(
                  SparkIcons.person, "Personalities", profile.personalities),
              buildProfileList(SparkIcons.skill, "Skills", profile.skills),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileItem(SparkIcons icon, String title, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Slightly rounded cornerss
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20.0,
                height: 20.0,
                child: SparkIcon(
                  icon: icon,
                  color: const Color(0xFF7F7E7E),
                  size: 15.0,
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                "$title:",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Flexible(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileList(SparkIcons icon, String title, List<String> items) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: SparkIcon(
                      icon: icon,
                      color: const Color(0xFF7F7E7E),
                      size: 15.0,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "$title:",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (items.isNotEmpty) ...[
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
          ],
        ],
      ),
    );
  }
}
