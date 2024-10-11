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
  late Map<String, dynamic> _detailProfileData;
  late List<String> _selectedInterestTags;
  late List<String> _availableInterestTags;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _detailProfileData = {
      'bio': '', //現在先預設沒資料==空字串
      'current_location': '',
      'hometown': '',
      'college': '',
      'job_title': '',
      'education_level': 'Prefer not to say',
      'mbti': 'Prefer not to say',
      'constellation': 'Prefer not to say',
      'blood_type': 'Prefer not to say',
      'religion': 'Prefer not to say',
      'sexuality': 'Prefer not to say',
      'ethnicity': 'Prefer not to say',
      'diet': 'Prefer not to say',
      'interest_types': [],
    };

    _selectedInterestTags = [];
    _availableInterestTags = List<String>.from(eventType);
  }

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
              value: _detailProfileData['bio'] ?? "",
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['bio'] = newValue;
                });
              },
              maxLine: 4,
            ),
            profileTextfield(
              label: 'Current Location',
              hintLabel: 'Enter current location',
              textFieldIcon: Icons.location_city,
              value: _detailProfileData['current_location'] ?? "",
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['current_location'] = newValue;
                });
              },
            ),
            profileTextfield(
              label: 'Hometown',
              hintLabel: 'Enter Hometown',
              textFieldIcon: Icons.home,
              value: _detailProfileData['hometown'] ?? "",
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['hometown'] = newValue;
                });
              },
            ),
            profileTextfield(
              label: 'College',
              hintLabel: 'Enter College',
              textFieldIcon: Icons.school,
              value: _detailProfileData['college'] ?? "",
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['college'] = newValue;
                });
              },
            ),
            profileTextfield(
              label: 'Job Title',
              hintLabel: 'Enter Job Title',
              textFieldIcon: Icons.home,
              value: _detailProfileData['job_title'] ?? "",
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['job_title'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Education',
              value: _detailProfileData['education_level'] ?? "",
              dropdownIcon: Icons.school,
              options: educationLevelList,
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['education_level'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'MBTI',
              value: _detailProfileData['mbti'] ?? "",
              dropdownIcon: Icons.person_add_outlined,
              options: mbtiList,
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['mbti'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Constellation',
              value: _detailProfileData['constellation'] ?? "",
              dropdownIcon: Icons.star_outline,
              options: constellationList,
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['constellation'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Blood Type',
              value: _detailProfileData['blood_type'] ?? "",
              dropdownIcon: Icons.water_drop_outlined,
              options: bloodTypeList,
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['blood_type'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Religion',
              value: _detailProfileData['religion'] ?? "",
              dropdownIcon: Icons.public_outlined,
              options: religionList,
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['religion'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Sexuality',
              value: _detailProfileData['sexuality'] ?? "",
              dropdownIcon: Icons.favorite_outline,
              options: sexualityList,
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['sexuality'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: "Ethnicity",
              value: _detailProfileData['ethnicity'] ?? "",
              dropdownIcon: Icons.group_outlined,
              options: ethnicityList,
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['ethnicity'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Diet',
              value: _detailProfileData['diet'] ?? "",
              dropdownIcon: Icons.restaurant_menu_outlined,
              options: dietList,
              onChanged: (newValue) {
                setState(() {
                  _detailProfileData['diet'] = newValue;
                });
              },
            ),
            profileTagSelector(
              label: "Interests",
              selectedTags: _selectedInterestTags,
              availableTags: _availableInterestTags,
              onChanged: (updatedTags) {
                setState(() {
                  _selectedInterestTags = updatedTags;
                });
              },
              isRequired: true,
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
                    onPressed: () => _saveProfile(),
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

  void _saveProfile() async {
// TODO: 跟server做上傳資料，上傳資料格式在_detailProfileData，作法應該跟profile_page一樣
    /*
      Key: bio, Value: null
      Key: current_location, Value: null
      Key: hometown, Value: null
      Key: college, Value: null
      Key: job_title, Value: null
      Key: education_level, Value: Prefer not to say
      Key: mbti, Value: Prefer not to say
      Key: constellation, Value: Prefer not to say
      Key: blood_type, Value: Prefer not to say
      Key: religion, Value: Prefer not to say
      Key: sexuality, Value: Prefer not to say
      Key: ethnicity, Value: Prefer not to say
      Key: diet, Value: Prefer not to say
      Key: skills, Value: null
      Key: personalities, Value: null
      Key: languages, Value: null
      Key: interest_types, Value: Sports,Travel
    */
    _detailProfileData.forEach((key, value) {
      debugPrint('Key: $key, Value: $value');
    });
    Navigator.pushNamed(context, RouteMap.eventTypeProfilePage);
  }
}
