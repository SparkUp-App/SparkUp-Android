import 'package:flutter/material.dart';
import 'package:spark_up/const_variable.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Map<String, String?> _profileData = {
    'bio': null,
    'name': null,
    'nickname': null,
    'phone': null,
    'home': null,
    'gender': null,
    'school': null,
    'marital_status': null,
    'birth_date': null,
    'career': null,
    'eat_habit': null,
    'interests': null,
  };

  final Map<String, List<String>> _dropdownOptions = {
    'gender': genderList,
    'marital_status': materialStatue,
    'zodiac_signs': zodiacSigns,
    'eat_habit': eatHabit,
  };


  List<String> _selectedInterestTags = []; //紀錄當前選擇的tag
  final List<String> _availableInterestTags = eventType;
  //List<String> _selectedSkillTags = [];

  // Available tags for selection
  //final List<String> _availableSkillTags = ["Dart", "Flutter", "Python"];

  Widget _buildTagSelector(String label, String key,List<String> selectedTags, List<String> availableTags) {
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
                Wrap(//更彈性的Row
                  spacing: 8,
                  runSpacing: 4,
                  children: selectedTags.map((tag) => Chip(
                    label: Text('#' + tag),
                    onDeleted: () {
                      setState(() {
                        selectedTags.remove(tag);
                        _profileData[key] = selectedTags.join(','); //要時刻記錄當前操作資訊，避免在這一層刪除資訊但沒紀錄到
                      });
                    },
                    deleteIconColor: Colors.grey,
                    backgroundColor: Colors.grey[200],
                  )).toList(),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () => _showTagSelectionDialog(label, key, selectedTags, availableTags),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '+',
                      style: TextStyle(
                        color:Colors.grey,
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

void _showTagSelectionDialog(String label, String key, List<String> selectedTags, List<String> availableTags) {
  showDialog(
    context: context, 
    barrierDismissible: false, // 防止點擊外部關閉
    builder: (BuildContext context) {
      return StatefulBuilder( //點擊按下要改變背景顏色，需要這一層來控制
        builder: (context, setState) { 
          return AlertDialog(
            title: Text('選擇你的' + label),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8.0,
                  children: availableTags.map((String tag) {
                    return FilterChip(
                      label: Text("#" + tag),
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
                child: const Text('確定'),
                onPressed: () {
                  Navigator.of(context).pop(); // 關閉對話框
                },
              ),
            ],
          );
        },
      );
    },
  ).then((_) { //等上面確認跳出視窗後，再做setState更新資訊(使_profileData能吃到更新資訊)，並且更新使selectedTags.map((tag) => Chip重新運作
    setState(() { //這裡只要等按下確認後更新資訊就好
      _profileData[label] = selectedTags.join(',');
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
                style: const TextStyle(color:Colors.black,fontSize: 16, fontWeight: FontWeight.bold),
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
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              hint: const Text('Select Here', style: TextStyle(color: Colors.black26),),
              items: _dropdownOptions[key]?.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList() ?? [],
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

  Widget _buildDatePicker(String label, String key) {
    TextEditingController controller = TextEditingController(text: _profileData[key] ?? '');

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
                    String formattedDate = "${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}";
                    _profileData[key] = formattedDate;
                    controller.text = formattedDate;
                  });
                }
              },
              child: IgnorePointer( //忽略點擊的textfield，只做顯示
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    hintText: "xxxx/xx/xx",
                    hintStyle: TextStyle(color: Colors.black26),
                    icon: Icon(Icons.edit_calendar)
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String key, {int maxLines = 1, bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // 確保所有文本在垂直方向上對齊
        children: [
          SizedBox(
            width: 140,
            child: RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                hintText: "Enter $label here",
                hintStyle: const TextStyle(color: Colors.black26),
              ),
              onChanged: (value) {
                setState(() {
                  _profileData[key] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          _buildTextField('Name', 'name', isRequired: true),
          _buildTextField('Nick Name', 'nickname',isRequired: true),
          _buildTextField('Phone', 'phone', isRequired: true),
          _buildDropdown('Gender', 'gender', isRequired:true),
          _buildDatePicker('Birthday', 'birth_date'),
          _buildDropdown('Diet', 'eat_habit'),
          _buildTextField('Career', 'career'),
          _buildTextField('School', 'school'),
          _buildTextField('Address', 'home'),
          _buildDropdown('Material status', 'marital_status'),
          _buildDropdown('Zodiac', 'zodiac_signs'),
          _buildTagSelector(
            'Intrest', 
            'Intrest',
            _selectedInterestTags, 
            _availableInterestTags, 
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveProfile,
            child: const Text('Save'),
          ),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }

  void _saveProfile() {
    if(_profileData['name']==null||
    _profileData['nickname']==null||
    _profileData['gender']==null||
    _profileData['phone']==null
    ){
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "The required information should be accurately filled out.",
      );
    }
    // TODO: 跟server做上傳資料，上傳資料格式在_profileData

    _profileData.forEach((key, value) {
      debugPrint('Key: $key, Value: $value');
    });
  }
}
