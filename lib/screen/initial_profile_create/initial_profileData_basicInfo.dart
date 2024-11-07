import 'package:flutter/material.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/profile.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart'; // 建立 common_widget
import 'package:spark_up/common_widget/profile_DatePicker.dart'; // 建立 common_widget
import 'package:spark_up/common_widget/profile_DropDown.dart'; // 建立 common_widget
import 'package:spark_up/common_widget/profile_TagSelector.dart'; 
import "package:spark_up/route.dart";

class BasicProfilePage extends StatefulWidget {
  const BasicProfilePage({super.key});

  @override
  State<BasicProfilePage> createState() => _BasicProfilePageState();
}

class _BasicProfilePageState extends State<BasicProfilePage> {
  bool _isKeyboardVisible = false;
  List<String> _availableLanguageTags = List<String>.from(languageType);
  List<String> _selectedLanguageTags = [];

  @override
  void initState() {
    super.initState();
    _initializeLanguageTags();
  }

  void _initializeLanguageTags() {
    // 假設 Profile.manager.language 存儲了用戶的興趣標籤
    _selectedLanguageTags = List<String>.from(Profile.manager.languages);
    _availableLanguageTags.removeWhere((tag) => _selectedLanguageTags.contains(tag));
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
        body: SafeArea(
          child: Stack(
            children: [
              // 放置在Stack的第一層，作為背景的可滾動內容
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                      textFieldIcon: 'assets/icons/phone.svg',
                      value: Profile.manager.phone,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.phone = newValue ?? "";
                        });
                      },
                      isRequired: true,
                    ),
                    profileTextfield(
                      label: 'Nickname',
                      hintLabel: 'Enter nickname',
                      textFieldIcon: 'assets/icons/user.svg',
                      value: Profile.manager.nickname,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.nickname = newValue ?? "";
                        });
                      },
                      isRequired: true,
                    ),
                    profieldDatepicker(
                      label: 'Date of Birth',
                      value: Profile.manager.dob,
                      datepickerIcon: 'assets/icons/calendar.svg',
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.dob = newValue ?? "";
                        });
                      },
                      isRequired: true,
                    ),
                    profileDropdown(
                      label: 'Gender',
                      value: Profile.manager.gneder.label,
                      dropdownIcon: 'assets/icons/gender.svg',
                      options: genderList,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.gneder = Gender.fromString(
                              newValue ?? "Prefer not to say");
                        });
                      },
                      isRequired: true,
                    ),
                     ProfileTagSelect(
                      label: 'Language',
                      selectedTags: _selectedLanguageTags,
                      availableTags: _availableLanguageTags,
                      onChanged: (updatedTags) {
                        setState(() {
                          _selectedLanguageTags = updatedTags;
                          _availableLanguageTags = List<String>.from(eventType)..removeWhere((tag) => _selectedLanguageTags.contains(tag));
                          Profile.manager.languages = _selectedLanguageTags;
                        });
                      },
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
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      border: const Border(top: BorderSide(color: Colors.black12)),
                      color:Colors.white.withOpacity(0.9),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 47,
                          child:ElevatedButton(
                            onPressed: () =>{
                              _navigateToDetailedProfile()
                            },
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

            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetailedProfile() {
    if (Profile.manager.phone.isEmpty == true ||
        Profile.manager.nickname.isEmpty == true ||
        Profile.manager.dob.isEmpty == true) {
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "Please fill in all required fields.", // 防止跳轉前的檢查
      );
      return;
    } else if (!phoneRegex.hasMatch(Profile.manager.phone)) {
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Please fill in correct phone number");
      return;
    }
    print(_selectedLanguageTags);
    Navigator.pushNamed(context, RouteMap.detailProfilePage);
  }
}
