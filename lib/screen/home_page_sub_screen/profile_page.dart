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
  late Profile profileTransformer;
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

  final List<String> _selectedInterestTags = []; //紀錄當前選擇的tag
  final List<String> _availableInterestTags = eventType;

  Widget _buildTagSelector(String label, String key, List<String> selectedTags,
      List<String> availableTags) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  //更彈性的Row
                  spacing: 8,
                  runSpacing: 4,
                  children: selectedTags
                      .map((tag) => Chip(
                            label: Text('#$tag'),
                            onDeleted: () {
                              setState(() {
                                selectedTags.remove(tag);
                                _profileData[key] = selectedTags
                                    .join(','); //要時刻記錄當前操作資訊，避免在這一層刪除資訊但沒紀錄到
                              });
                            },
                            deleteIconColor: Colors.grey,
                            backgroundColor: Colors.grey[200],
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _showTagSelectionDialog(
                      label, key, selectedTags, availableTags),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
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
                            } else {
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
        _profileData[key] = selectedTags.join(',');
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
                      hintText: "xxxx-xx-xx",
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Network.manager.sendRequest(
          method: RequestMethod.get,
          path: ProfilePath.view,
          pathMid: ["${Network.manager.userId}"]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          profileTransformer = Profile.initfromData(snapshot.data!["data"]);
          _profileData = profileTransformer.toProfile;
          _textContollerMap = _profileData.map((key, value) =>
              value.runtimeType == String
                  ? MapEntry(key, TextEditingController(text: value))
                  : MapEntry(key, TextEditingController()));
          return Stack(children: [
            Scaffold(
              body: ListView(
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
                  _buildTextField('Bio', 'bio', maxLines: 4),
                  const Text(
                    "My Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //_buildTextField('Name', 'name', isRequired: true),
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
                  // Doesn't have language , personalities , skills
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
            ),
            if (isLoading) ...[
              Opacity(
                opacity: 0.8,
                child: Container(
                  color: Colors.black,
                ),
              ),
              const Center(child: CircularProgressIndicator())
            ]
          ]);
        } else {
          return Center(child: Text("Error: ${snapshot.data!["status"]}"));
        }
      },
    );
  }

  void _saveProfile() async {
    if ( //如果資料不對，應該要在這裡阻斷
        _profileData['nickname'] == null ||
            _profileData['gender'] == null ||
            _profileData['phone'] == null ||
            _profileData['dob'] == null) {
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "The required information should be accurately filled out.",
      );
      return;
    }

    _profileData.forEach((key, value) {
      debugPrint('Key: $key, Value: $value');
    });

    setState(() {
      isLoading = true;
    });

    profileTransformer = Profile.initfromData(_profileData);

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
