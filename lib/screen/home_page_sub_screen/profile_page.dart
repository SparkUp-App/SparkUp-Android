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
    //'name': null,
    'phone': '',
    'nickname': '',
    'dob': '',
    'gender': 'Prefer not to say', //給空字串會炸，除非我們genderList加一個''
    'bio': '',
    'current_location': '',
    'hometown':'',
    'college': '',
    'job_title':'',
    'education_level': 'Prefer not to say',
    'mbti':'Prefer not to say',
    'constellation': 'Prefer not to say',
    'blood_type': 'Prefer not to say',
    'religion': 'Prefer not to say',
    'sexuality':'Prefer not to say',
    'ethnicity':'Prefer not to say',
    'diet':'Prefer not to say',
    /*
    'smoke':'Prefer not to say',
    'drinking':'Prefer not to say',
    'marijuana':'Prefer not to say',
    'drugs':'Prefer not to say',
    */    
    'skills':null,
    'personalities':null,
    'languages':null,
    'interest_types':null,
  };

  final Map<String, List<String>> _dropdownOptions = {
    'gender': genderList,
    'education_level':educationLevelList,
    'mbti':mbtiList,
    'constellation':constellationList,
    'blood_type':bloodTypeList,
    'religion':religionList,
    'sexuality':sexualityList,
    'ethnicity':ethnicityList,
    'diet':dietList,
  };
  late Map<String, TextEditingController> _controllers; //TextField改用TextEditingController去防問題，也避免他重製輸入標
  @override
  void initState() {
    super.initState();
    _controllers = {
      'phone': TextEditingController(text: _profileData['phone'] ?? ''),
      'nickname': TextEditingController(text: _profileData['nickname'] ?? ''),
      'bio': TextEditingController(text: _profileData['bio'] ?? ''),
      'current_location': TextEditingController(text: _profileData['current_location'] ?? ''),
      'hometown': TextEditingController(text: _profileData['hometown'] ?? ''),
      'college': TextEditingController(text: _profileData['college'] ?? ''),
      'job_title': TextEditingController(text: _profileData['job_title'] ?? ''),
    };

    // 為每個控制器添加Listener
    //宣告各自textEditingController去做到"當文本更新的時候，自動同步到_profiledData上"
    _controllers.forEach((key, controller) {
      controller.addListener(() {
        // 當文本變化時，更新 _profileData 中對應的值
        _profileData[key] = controller.text;
      });
    });
  }
  final List<String> _selectedInterestTags = []; //紀錄當前選擇的tag
  final List<String> _availableInterestTags = eventType;

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
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _showTagSelectionDialog(label, key, selectedTags, availableTags),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
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
            title: Text('Choose your ' + label),
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
  ).then((_) { //等上面確認跳出視窗後，再做setState更新資訊(使_profileData能吃到更新資訊)，並且更新使selectedTags.map((tag) => Chip重新運作
    setState(() { //只要這個視窗跳走，就會記錄當前有的資訊
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

  Widget _buildDatePicker(String label, String key,{bool isRequired = false}) {
    TextEditingController controller = TextEditingController(text: _profileData[key] ?? '');

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
                    String formattedDate = selectedDate.toIso8601String().split('T')[0]; //ISO format
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
                    hintText: "xxxx-xx-xx",
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
              controller: _controllers[key], //放棄根據_profileData的string進行防守。改利用textEditingController去防
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
          _buildTextField('Phone', 'phone', isRequired: true),
          _buildTextField('Nick Name', 'nickname',isRequired: true),
          _buildDatePicker('Birthday', 'dob',isRequired:true),
          _buildDropdown('Gender', 'gender', isRequired:true),
          _buildTextField('Current Location','current_location'),
          _buildTextField('Hometown','hometown'),
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
          // Doesn't have drugs , smoke , drinking , marijuana

          _buildTagSelector(
            'Intrest', 
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
          const SizedBox(height: 30,)
        ],
      ),
    );
  }

  void _saveProfile() {
    if( //如果資料不對，應該要在這裡阻斷
    _profileData['nickname']?.length==0||
    _profileData['gender']?.length==0||
    _profileData['phone']?.length==0||
    _profileData['dob']?.length==0
    ){
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "The required information should be accurately filled out.",
      );
      return;
    }
    // TODO: 跟server做上傳資料，上傳資料格式在_profileData
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
  }
}
