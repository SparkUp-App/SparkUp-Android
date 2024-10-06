import 'package:flutter/material.dart';
import 'package:spark_up/const_variable.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import 'package:spark_up/common_widget/profile_Textfield.dart'; //建立common_widget
import 'package:spark_up/common_widget/profile_DatePicker.dart';//建立common_widget
import 'package:spark_up/common_widget/profile_DropDown.dart';//建立common_widget

import 'package:spark_up/screen/initial_profile_create/initial_profileData_detail.dart';//導航到detail頁面，順便將當前basicInfo資料賺到detail身上

class BasicProfilePage extends StatefulWidget {
  const BasicProfilePage({Key? key}) : super(key: key);

  @override
  _BasicProfilePageState createState() => _BasicProfilePageState();
}

class _BasicProfilePageState extends State<BasicProfilePage> {
  final Map<String, String?> _basicProfileData = {
    'phone': '',
    'nickname': '',
    'dob': '',
    'gender': 'Prefer not to say',
  };

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Profile'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Center(
            child: Text(
            "Please fill in the required information",
            style: TextStyle(
              color: Colors.black26,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ),
          profileTextfield(
            label: 'Phone',
            hintLabel: 'Enter phone number',
            textFieldIcon: Icons.phone,
            value: _basicProfileData['phone']??"",
            onChanged: (newValue) {
              setState(() {
                _basicProfileData['phone'] = newValue;
              });
            },
            isRequired: true,
          ),
          profileTextfield(
            label: 'nickname',
            hintLabel: 'Enter nickname',
            textFieldIcon: Icons.person,
            value: _basicProfileData['nickname']??"",
            onChanged: (newValue) {
              setState(() {
                _basicProfileData['nickname'] = newValue;
              });
            },
            isRequired: true,
          ),
          profieldDatepicker(
            label: 'Date of Birth', 
            value: _basicProfileData['dob']??"",
            datepickerIcon: Icons.calendar_month_rounded,
            onChanged: (newValue) {
              setState(() {
                _basicProfileData['dob'] = newValue;
              });
            },
            isRequired: true,
          ),
          profileDropdown(
            label: 'Gender', 
            value: _basicProfileData['gender']??"", 
            dropdownIcon: Icons.ac_unit,
            options: genderList, 
            onChanged:(newValue) {
              setState(() {
                _basicProfileData['gender'] = newValue;
              });
            },
            isRequired: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _navigateToDetailedProfile,//導航到detail頁面
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailedProfile() {
    if (_basicProfileData['phone']?.isEmpty == true ||
        _basicProfileData['nickname']?.isEmpty == true ||
        _basicProfileData['dob']?.isEmpty == true ||
        _basicProfileData['gender']?.isEmpty == true) {
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "Please fill in all required fields.",//在這裡防必要資訊沒有填好的部分
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedProfilePage(basicProfileData: _basicProfileData),//導航到detail頁面，順便將當前basicInfo資料賺到detail身上
      ),
    );
  }
}
//這裡部處理任何資料上傳的部分，這裡填寫的資訊都會被帶到下一頁(initial_profileData_detail)當中，所以這裡完全不用跟server連動，要就只要處理detail那一頁