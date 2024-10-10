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
  final Map<String, String?> basicProfileData;

  const DetailedProfilePage({super.key, required this.basicProfileData});

  @override
  _DetailedProfilePageState createState() => _DetailedProfilePageState();
}

class _DetailedProfilePageState extends State<DetailedProfilePage> {
  bool isLoading = false;
  late Map<String, dynamic> _profileData;
  late List<String> _selectedInterestTags;
  late List<String> _availableInterestTags;

  @override
  void initState() {
    super.initState();
    _profileData = {
      ...widget.basicProfileData, //將basicInfo在此組合，所以只需要對_profileData進行包裝成.json格式送給brian就好
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
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: Stack(children: [
        ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              "About Me",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Make it easy for others to get a sense of who you are",
              style: TextStyle(
                color: Colors.black26,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            profileTextfield(
              label: 'Bio',
              hintLabel: 'Enter Bio',
              textFieldIcon: Icons.location_city,
              value: _profileData['bio'] ?? "",
              onChanged: (newValue) {
                setState(() {
                  _profileData['bio'] = newValue;
                });
              },
              maxLine: 4,
            ),
            const Text(
              "Additional Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            profileTextfield(
              label: 'Current Location',
              hintLabel: 'Enter current location',
              textFieldIcon: Icons.location_city,
              value: _profileData['current_location'] ?? "",
              onChanged: (newValue) {
                setState(() {
                  _profileData['current_location'] = newValue;
                });
              },
            ),
            profileTextfield(
              label: 'Hometown',
              hintLabel: 'Enter Hometown',
              textFieldIcon: Icons.home,
              value: _profileData['hometown'] ?? "",
              onChanged: (newValue) {
                setState(() {
                  _profileData['hometown'] = newValue;
                });
              },
            ),
            profileTextfield(
              label: 'College',
              hintLabel: 'Enter College',
              textFieldIcon: Icons.school,
              value: _profileData['college'] ?? "",
              onChanged: (newValue) {
                setState(() {
                  _profileData['college'] = newValue;
                });
              },
            ),
            profileTextfield(
              label: 'Job Title',
              hintLabel: 'Enter Job Title',
              textFieldIcon: Icons.home,
              value: _profileData['job_title'] ?? "",
              onChanged: (newValue) {
                setState(() {
                  _profileData['job_title'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Education',
              value: _profileData['education_level'] ?? "",
              dropdownIcon: Icons.school,
              options: educationLevelList,
              onChanged: (newValue) {
                setState(() {
                  _profileData['education_level'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'MBTI',
              value: _profileData['mbti'] ?? "",
              dropdownIcon: Icons.person_add_outlined,
              options: mbtiList,
              onChanged: (newValue) {
                setState(() {
                  _profileData['mbti'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Constellation',
              value: _profileData['constellation'] ?? "",
              dropdownIcon: Icons.star_outline,
              options: constellationList,
              onChanged: (newValue) {
                setState(() {
                  _profileData['constellation'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Blood Type',
              value: _profileData['blood_type'] ?? "",
              dropdownIcon: Icons.water_drop_outlined,
              options: bloodTypeList,
              onChanged: (newValue) {
                setState(() {
                  _profileData['blood_type'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Religion',
              value: _profileData['religion'] ?? "",
              dropdownIcon: Icons.public_outlined,
              options: religionList,
              onChanged: (newValue) {
                setState(() {
                  _profileData['religion'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Sexuality',
              value: _profileData['sexuality'] ?? "",
              dropdownIcon: Icons.favorite_outline,
              options: sexualityList,
              onChanged: (newValue) {
                setState(() {
                  _profileData['sexuality'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: "Ethnicity",
              value: _profileData['ethnicity'] ?? "",
              dropdownIcon: Icons.group_outlined,
              options: ethnicityList,
              onChanged: (newValue) {
                setState(() {
                  _profileData['ethnicity'] = newValue;
                });
              },
            ),
            profileDropdown(
              label: 'Diet',
              value: _profileData['diet'] ?? "",
              dropdownIcon: Icons.restaurant_menu_outlined,
              options: dietList,
              onChanged: (newValue) {
                setState(() {
                  _profileData['diet'] = newValue;
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save'),
            ),
            const SizedBox(
              height: 30,
            )
          ],
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
        ]
      ]),
    );
  }

  void _saveProfile() async {
// TODO: 跟server做上傳資料，上傳資料格式在_profileData，作法應該跟profile_page一樣
    /*
      Key: phone, Value: CCCC
      Key: nickname, Value: DDDD
      Key: dob, Value: 2004/01/14
      Key: gender, Value: Female
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
    _profileData.forEach((key, value) {
      debugPrint('Key: $key, Value: $value');
    });

    final Profile profileTransformer = Profile.initfromData(_profileData);

    setState(() => isLoading = true);

    debugPrint("Sending Update Profile Request");
    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: ProfilePath.update,
        pathMid: ["${Network.manager.userId}"],
        data: profileTransformer.toMap);
    debugPrint("Finished Update Profile Request");

    setState(() => isLoading = false);

    if (response["status"] == "success") {
      Profile.manager = profileTransformer;
      Navigator.pushNamed(context, RouteMap.homePage);
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              SystemMessage(content: "${response["data"]["message"]}"));
    }
  }
}
