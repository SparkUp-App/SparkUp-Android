import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/profile.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/profile_path.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isLoading = false;
  late Map<String, dynamic> _profileData;
  late Map<String, TextEditingController> _textContollerMap;

  final Map<String, List<String>> _dropdownOptions = {
    'gender': genderList,
    'education_level': educationLevelList,
    'mbti': mbtiList,
    'constellation': constellationList,
    'blood_type': bloodTypeList,
    'religion': religionList,
    'sexuality': sexualityList,
    'ethnicity': ethnicityList,
    'diet': dietList,
    'smoke': smokeList,
    'drinking': drinkingList,
    'marijuana': marijuanaList,
    'drugs': drugsList,
  };

  late List<String> _selectedInterestTags; //紀錄當前選擇的tag
  late List<String> _availableInterestTags;
  late List<String> _selectedLanguageTags; //紀錄當前選擇的tag
  late List<String> _availableLanguageTags;
  @override
  initState() {
    super.initState();

    _profileData = Profile.manager.toProfile;
    _textContollerMap = _profileData.map(
      (key, value) {
        return value.runtimeType == String
            ? MapEntry(key, TextEditingController(text: value))
            : MapEntry(key, TextEditingController());
      },
    );

    _availableInterestTags = List<String>.from(eventType);
    _selectedInterestTags = List<String>.from(_profileData["interest_types"] ?? []);
    _availableLanguageTags = List<String>.from(languageType);
    _selectedLanguageTags = List<String>.from(_profileData["language"] ?? []);
    for (var type in _selectedInterestTags) {
      _availableInterestTags.remove(type);
    }
    for (var lang in _selectedLanguageTags) {
      _availableLanguageTags.remove(lang);
    }
  }

  Widget _buildTagSelector(String label, String key, List<String> selectedTags, List<String> availableTags) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFF16743), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedTags.length,
                      itemBuilder: (context, index) {
                        final tag = selectedTags[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Chip(
                            label: Text('#$tag'),
                            onDeleted: () {
                              setState(() {
                                selectedTags.remove(tag);
                                availableTags.add(tag);
                                _profileData[key] = selectedTags;
                              });
                            },
                            deleteIconColor: Colors.grey,
                            backgroundColor: Colors.grey[200],
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Color(0xFFF16743)),
                    onPressed: () => _showTagSelectionDialog(
                      label,
                      key,
                      selectedTags,
                      availableTags,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTagSelectionDialog(String label, String key,
      List<String> selectedTags, List<String> availableTags) {
    showDialog(
      context: context,
      barrierDismissible: false, // 防止點擊外部關閉
      builder: (BuildContext context) {
        return StatefulBuilder(
          //點擊按下要改變背景顏色，需要這一層來控制
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Choose your $label'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8.0,
                    children: availableTags.map((String tag) {
                      return FilterChip(
                        label: Text("#$tag"),
                        selected: selectedTags.contains(tag),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedTags.add(tag);
                              availableTags.remove(tag);
                            } else {
                              availableTags.remove(tag);
                              selectedTags.remove(tag);
                            }
                          });
                        },
                        showCheckmark: false,
                        selectedColor: Colors.blueAccent.withOpacity(0.3),
                        backgroundColor: Colors.grey[200],
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop(); // 關閉對話框
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      //等上面確認跳出視窗後，再做setState更新資訊(使_profileData能吃到更新資訊)，並且更新使selectedTags.map((tag) => Chip重新運作
      setState(() {
        //只要這個視窗跳走，就會記錄當前有的資訊
        _profileData[key] = selectedTags;
      });
    });
  }

  Widget _buildDropdown(String label, String key, {isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                children: [
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _profileData[key],
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              hint: const Text(
                'Select Here',
                style: TextStyle(color: Colors.black26),
              ),
              items: _dropdownOptions[key]?.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList() ??
                  [],
              onChanged: (String? newValue) {
                setState(() {
                  _profileData[key] = newValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, String key, {bool isRequired = false}) {
    TextEditingController controller =
        TextEditingController(text: _profileData[key] ?? '');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: [
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2004),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (selectedDate != null) {
                  setState(() {
                    String formattedDate = selectedDate
                        .toIso8601String()
                        .split('T')[0]; //ISO format
                    _profileData[key] = formattedDate;
                    controller.text = formattedDate;
                  });
                }
              },
              child: IgnorePointer(
                //忽略點擊的textfield，只做顯示
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      hintText: "yyyy-mm-dd",
                      hintStyle: TextStyle(color: Colors.black26),
                      icon: Icon(Icons.edit_calendar)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String key,
      {int maxLines = 1, bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: [
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextField(
              maxLines: maxLines,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                hintText: "Enter $label here",
                hintStyle: const TextStyle(color: Colors.black26),
              ),
              controller: _textContollerMap[key],
              onChanged: (value) {
                _profileData[key] = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: ProfileTheme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: ProfileTheme.subtitleColor,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'IowanOldStyle',
        scaffoldBackgroundColor: ProfileTheme.backgroundColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ProfileTheme.textColor,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(12.0),
              children: [
                _buildSectionTitle(
                  "About Me",
                  subtitle: "Make it easy for others to get a sense of who you are",
                ),
                _buildTextField('Bio', 'bio', maxLines: 4),
                _buildTextField('Phone', 'phone', isRequired: true),
                _buildTextField('Nick Name', 'nickname', isRequired: true),
                _buildDatePicker('Birthday', 'dob', isRequired: true),
                _buildDropdown('Gender', 'gender', isRequired: true),
                _buildTextField('Current Location', 'current_location'),
                _buildTextField('Hometown', 'hometown'),
                _buildTextField('College', 'college'),
                _buildTextField('Job Title', 'job_title'),
                _buildDropdown('Education', 'education_level'),
                _buildDropdown('MBTI', 'mbti'),
                _buildDropdown('Constellation', 'constellation'),
                _buildDropdown('Blood Type', 'blood_type'),
                _buildDropdown('Religion', 'religion'),
                _buildDropdown('Sexuality', 'sexuality'),
                _buildDropdown("Ethnicity", 'ethnicity'),
                _buildDropdown('Diet', 'diet'),
                _buildDropdown('Smoke', 'smoke'),
                _buildDropdown('Drinking', 'drinking'),
                _buildDropdown('Marijuana', 'marijuana'),
                _buildDropdown('Drugs', 'drugs'),

                _buildTagSelector(
                  'Inetrest',
                  'interest_types',
                  _selectedInterestTags,
                  _availableInterestTags,
                ),
                _buildTagSelector(
                  'Language',
                  'Language',
                  _selectedLanguageTags,
                  _availableLanguageTags,
                ),
                // Doesn't have language , personalities , skills
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ProfileTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ProfileTheme.primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    if ( //如果資料不對，應該要在這裡阻斷
        _profileData['nickname'] == "" ||
            _profileData['gender'] == "" ||
            _profileData['phone'] == "" ||
            _profileData['dob'] == "") {
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "The required information should be accurately filled out.",
      );
      return;
    } else if (!phoneRegex.hasMatch(_profileData["phone"])) {
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Pleas filled the correct phone number");
      return;
    }

    _profileData.forEach((key, value) {
      debugPrint('Key: $key, Value: $value');
    });

    setState(() {
      isLoading = true;
    });

    Profile profileTransformer = Profile.initfromData(_profileData);

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: ProfilePath.update,
        pathMid: ["${Network.manager.userId}"],
        data: profileTransformer.toMap);

    setState(() {
      isLoading = false;
    });

    if (context.mounted) {
      if (response["status"] == "success") {
        Profile.manager = profileTransformer;
        showDialog(
          context: context,
          builder: (context) {
            return const SystemMessage(content: "Profile Update Success");
          },
        );
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const SystemMessage(content: "Profile Update Failed");
            });
      }
    }
  }
}

// 添加一個常量類來存儲顏色
class ProfileTheme {
  static const Color primaryColor = Color(0xFFF16743);
  static const Color secondaryColor = Color(0xFF2E3A59);
  static const Color backgroundColor = Color(0xFFF5F6FA);
  static const Color textColor = Color(0xFF2E3A59);
  static const Color subtitleColor = Color(0xFF8F9BB3);
}
