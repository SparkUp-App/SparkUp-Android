import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/profile.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/profile_path.dart';
import 'package:spark_up/route.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:spark_up/common_widget/profile_DropDown.dart';
import 'package:spark_up/common_widget/profile_TagSelector.dart';

//這裡有的資料除了自己這一頁以外，還有夾帶上一頁basicInfo的資訊
class DetailedProfilePage extends StatefulWidget {

  const DetailedProfilePage({super.key});
  @override
  _DetailedProfilePageState createState() => _DetailedProfilePageState();
}

class _DetailedProfilePageState extends State<DetailedProfilePage> {
  bool isLoading = false;
  bool _isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    if (isKeyboardVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isKeyboardVisible;
      });
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF16743), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
      body:SafeArea(child:Stack(
        children: [
          SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
                children: [
            SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "If you want others know more",
                            style: TextStyle(
                              fontFamily: 'IowanOldStyle',
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "about you...",
                            style: TextStyle(
                              fontFamily: 'IowanOldStyle',
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            profileTextfield(
              label: 'Bio',
              hintLabel: 'Enter Bio',
              textFieldIcon: Icons.location_city,
              value: Profile.manager.bio,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.bio = newValue ?? "";
                });
              },
              maxLine: 4,
            ),
            profileTextfield(
              label: 'Current Location',
              hintLabel: 'Enter current location',
              textFieldIcon: Icons.location_city,
              value: Profile.manager.currentLocation,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.currentLocation = newValue ?? "";
                });
              },
            ),
            profileTextfield(
              label: 'Hometown',
              hintLabel: 'Enter Hometown',
              textFieldIcon: Icons.home,
              value: Profile.manager.hoemTown,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.hoemTown = newValue ?? "";
                });
              },
            ),
            profileTextfield(
              label: 'College',
              hintLabel: 'Enter College',
              textFieldIcon: Icons.school,
              value: Profile.manager.college,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.college = newValue ?? "";
                });
              },
            ),
            profileTextfield(
              label: 'Job Title',
              hintLabel: 'Enter Job Title',
              textFieldIcon: Icons.home,
              value: Profile.manager.jobTitle,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.jobTitle = newValue ?? "";
                });
              },
            ),
            profileDropdown(
              label: 'Education',
              value: Profile.manager.educationLevel,
              dropdownIcon: Icons.school,
              options: educationLevelList,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.educationLevel = newValue ?? "";
                });
              },
            ),
            profileDropdown(
              label: 'MBTI',
              value: Profile.manager.mbti,
              dropdownIcon: Icons.person_add_outlined,
              options: mbtiList,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.mbti = newValue ?? "Prefer not to say";
                });
              },
            ),
            profileDropdown(
              label: 'Constellation',
              value: Profile.manager.constellation,
              dropdownIcon: Icons.star_outline,
              options: constellationList,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.constellation = newValue ?? "Prefer not to say";
                });
              },
            ),
            profileDropdown(
              label: 'Blood Type',
              value: Profile.manager.bloodType,
              dropdownIcon: Icons.water_drop_outlined,
              options: bloodTypeList,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.bloodType = newValue ?? "Prefer not to say";
                });
              },
            ),
            profileDropdown(
              label: 'Religion',
              value: Profile.manager.religion,
              dropdownIcon: Icons.public_outlined,
              options: religionList,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.religion = newValue ?? "Prefer not to say";
                });
              },
            ),
            profileDropdown(
              label: 'Sexuality',
              value: Profile.manager.sexuality,
              dropdownIcon: Icons.favorite_outline,
              options: sexualityList,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.sexuality = newValue ?? "Prefer not to say";
                });
              },
            ),
            profileDropdown(
              label: "Ethnicity",
              value: Profile.manager.ethnicity,
              dropdownIcon: Icons.group_outlined,
              options: ethnicityList,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.ethnicity = newValue ?? "Prefer not to say";
                });
              },
            ),
            profileDropdown(
              label: 'Diet',
              value: Profile.manager.diet,
              dropdownIcon: Icons.restaurant_menu_outlined,
              options: dietList,
              onChanged: (newValue) {
                setState(() {
                  Profile.manager.diet = newValue ?? "Prefer not to say";
                });
              },
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
          ),
        if (isLoading) ...[
          Opacity(
            opacity: 0.8,
            child: Container(
              color: Colors.black,
            ),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
        Visibility(
          visible: !isKeyboardVisible,
          child: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100, // 設置背景的高度
            child: Container(
              //color: Colors.white.withOpacity(0.95),// 淺白色背景
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black12)), 
                color:Colors.white.withOpacity(0.9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                  width: 150,
                  height: 47,
                  child:ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, RouteMap.initialProfileDataPage),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF16743),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: 'IowanOldStyle',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ),
                  SizedBox(
                  width: 150,
                  height: 47,
                  child:ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, RouteMap.eventTypeProfilePage),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF16743),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'IowanOldStyle',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]
      ),
      ),
      ),
    );
  }
}
