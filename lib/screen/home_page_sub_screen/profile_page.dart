import 'package:flutter/material.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  Map<String, String?> _profileData = {
    'bio': null,
    'name': null,
    'nickname': null,
    'phone': null,
    'home':null,
    'gender': null,
    'school':null,
    'marital_status': null,
    'birth_date': null,
    'career':null,
    'eat_habit':null,
  };

  Map<String, List<String>> _dropdownOptions = {
    'gender': ['Male', 'Female', 'Non-Binary'],
    'marital_status': ['Single', 'Married'],
    'zodiac_signs':['Aries','Taurus','Gemini','Cancer','Leo','Virgo','Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces'],
    'eat_habit':['meat-based','Vegan','Lacto-vegetarian'],
  };

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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              children: [
                if (isRequired)
                  TextSpan(
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
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            hint: Text('請選擇'),
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
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  _profileData[key] = "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
                });
              }
            },
            child: IgnorePointer(
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  hintText: _profileData[key] ?? '請選擇日期',
                  hintStyle: TextStyle(
                    color: _profileData[key] == null ? Colors.black54 : Colors.black,
                  ),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            validator: isRequired
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入$label';
                    }
                    return null;
                  }
                : null,
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
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            "About Me",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Make it easy for others to get a sense of who you are",
            style: TextStyle(
              color: Colors.black26,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildTextField('個人簡介', 'bio', maxLines: 4),
          Text(
            "My Details",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildTextField('姓名', 'name', isRequired: true),
          _buildTextField('暱稱', 'nickname',isRequired: true),
          _buildTextField('電話', 'phone', isRequired: true),
          _buildDropdown('性別', 'gender', isRequired:true),
          _buildDatePicker('出生日期', 'birth_date'),
          _buildDropdown('飲食習慣', 'eat_habit'),
          _buildTextField('職業', 'career'),
          _buildTextField('學校', 'school'),
          _buildTextField('居住地', 'home'),
          _buildDropdown('婚姻狀況', 'marital_status'),
          _buildDropdown('星座', 'zodiac_signs'),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('保存'),
            onPressed: _saveProfile,
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    if(_profileData['name']==null||_profileData['nickname']==null||_profileData['gender']==null||_profileData['phone']==null){
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "有些必填資訊未如實填寫",
      );
    }
    // TODO: 跟server做上傳資料，上傳資料格式在_profileData
    
    _profileData.forEach((key, value) {
      print('Key: $key, Value: $value');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('個人資料已更新')),
    );
  }
}
