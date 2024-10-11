import 'package:flutter/material.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/profile.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart'; // 建立 common_widget
import 'package:spark_up/common_widget/profile_DatePicker.dart'; // 建立 common_widget
import 'package:spark_up/common_widget/profile_DropDown.dart'; // 建立 common_widget
import 'package:spark_up/screen/initial_profile_create/initial_profileData_detail.dart'; // 導航到 detail 頁面，並將當前 basicInfo 資料傳遞到 detail 頁面
import "package:spark_up/route.dart";

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
    'gender': 'Prefer not to say', //默認值
  };

  bool _isKeyboardVisible = false;
  //彥廷會做初始化

  //TODO

  @override
  void initState() {
    super.initState();
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
        body:SafeArea(
        child: Stack(
          children: [
            // 放置在Stack的第一層，作為背景的可滾動內容
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Before start",
                            style: TextStyle(
                              fontFamily: 'IowanOldStyle',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8), // 增加間距
                          Text(
                            "Let us know something about you...",
                            style: TextStyle(
                              fontFamily: 'IowanOldStyle',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  profileTextfield(
                    label: 'Phone',
                    hintLabel: 'Enter phone number',
                    textFieldIcon: Icons.phone,
                    value: _basicProfileData['phone'] ?? "",
                    onChanged: (newValue) {
                      setState(() {
                        _basicProfileData['phone'] = newValue;
                      });
                    },
                    isRequired: true,
                  ),
                  profileTextfield(
                    label: 'Nickname',
                    hintLabel: 'Enter nickname',
                    textFieldIcon: Icons.person,
                    value: _basicProfileData['nickname'] ?? "",
                    onChanged: (newValue) {
                      setState(() {
                        _basicProfileData['nickname'] = newValue;
                      });
                    },
                    isRequired: true,
                  ),
                  profieldDatepicker(
                    label: 'Date of Birth',
                    value: _basicProfileData['dob'] ?? "",
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
                    value: _basicProfileData['gender'] ?? "",
                    dropdownIcon: Icons.ac_unit,
                    options: genderList,
                    onChanged: (newValue) {
                      setState(() {
                        _basicProfileData['gender'] = newValue;
                      });
                    },
                    isRequired: true,
                  ),
                  const SizedBox(height: 100), // 預留一些空間以避免被按鈕遮住
                ],
              ),
            ),

            Visibility(
              visible: !isKeyboardVisible,
              child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 220,
                  height: 47,
                  child: ElevatedButton(
                    onPressed: () => _navigateToDetailedProfile(),
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
              ),
            ),
            ),
          ],
        ),
      ),

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
        message: "Please fill in all required fields.", // 防止跳轉前的檢查
      );
      return;
    }
    //Profile initial
    //Profile.manager.phone = _basicProfileData["phone"]!;
    
    //Profile initial
    Navigator.pushNamed(context, RouteMap.detailProfilePage);
  }
}
