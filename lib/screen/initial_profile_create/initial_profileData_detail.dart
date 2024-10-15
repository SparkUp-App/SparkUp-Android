import 'package:flutter/material.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/profile.dart';
import 'package:spark_up/route.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:spark_up/common_widget/profile_DropDown.dart';
import 'package:spark_up/common_widget/profile_MultiTextField.dart';

//這裡有的資料除了自己這一頁以外，還有夾帶上一頁basicInfo的資訊
class DetailedProfilePage extends StatefulWidget {

  const DetailedProfilePage({super.key});
  @override
  State<DetailedProfilePage> createState() => _DetailedProfilePageState();
}

class _DetailedProfilePageState extends State<DetailedProfilePage> {
  bool isLoading = false;
  bool _isKeyboardVisible = false;


  List<TextEditingController> skillControllers = []; //因為skills這個區塊，textfield是彈性成長，所以我用一個List記住他
  List<TextEditingController> personalitiesControllers = []; //因為skills這個區塊，textfield是彈性成長，所以我用一個List記住他

  void _updateSkills() { //如果有更新資訊的話，同步到Profile.manager.skills
    Profile.manager.skills = skillControllers.map((controller) => controller.text.trim()).where((skill) => skill.isNotEmpty).toList();
  }  
  void _initializeSkillControllers() { //根據Profile.manager.skills內有的資訊，先重新建立好"原本花了幾個TextField以及內容"
    skillControllers = Profile.manager.skills.map((skill) => TextEditingController(text: skill)).toList();
  }

  void _updatePersonalities() { //如果有更新資訊的話，同步到Profile.manager.skills
    Profile.manager.personalities = personalitiesControllers.map((controller) => controller.text.trim()).where((personalities) => personalities.isNotEmpty).toList();
  }  
  void _initializePersonalitiesControllers() { //根據Profile.manager.skills內有的資訊，先重新建立好"原本花了幾個TextField以及內容"
    personalitiesControllers = Profile.manager.personalities.map((personalities) => TextEditingController(text: personalities)).toList();
  }

  Widget SkillsInput(int index) { //SkillsInput，利用index去區分誰是誰
    return Center(
      child:
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        width: MediaQuery.of(context).size.width * 0.75,
        child: Stack(
          children:[
            TextFormField(
          controller: skillControllers[index],
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.safety_check),
            prefixIconColor: Colors.black26,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFE9765B)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintText: "Skill",
            hintStyle: const TextStyle(
              color: Colors.black26,
            ),
          ),
          onChanged: (value) {
            _updateSkills();
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              skillControllers[index].clear();
              skillControllers.removeAt(index);
              setState(() {
                _updateSkills();
              });
            },
            color: Colors.black26,
          ),
        )
        ],
      ),
      )

    );
  }

  Widget PersonalitiesInput(int index) { //SkillsInput，利用index去區分誰是誰
    return Center(
      child:
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        width: MediaQuery.of(context).size.width * 0.75,
        child: Stack(
          children:[
            TextFormField(
          controller: personalitiesControllers[index],
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.safety_check),
            prefixIconColor: Colors.black26,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFE9765B)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintText: "Skill",
            hintStyle: const TextStyle(
              color: Colors.black26,
            ),
          ),
          onChanged: (value) {
            _updatePersonalities();
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              personalitiesControllers[index].clear();
              personalitiesControllers.removeAt(index);
              setState(() {
                _updatePersonalities();
              });
            },
            color: Colors.black26,
          ),
        )
        ],
      ),
      )

    );
  }
  void initState() {
    super.initState();
    _initializeSkillControllers();//初始化SkillControllers資訊與textfield
    _initializePersonalitiesControllers();//初始化SkillControllers資訊與textfield
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
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                      value: Profile.manager.bio,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.bio = newValue ?? "";
                        });
                      },
                      maxLine: 4,
                    ),
                    profileTextfield(
                      label: 'Current Location',
                      hintLabel: 'Enter current location',
                      textFieldIcon: Icons.location_city,
                      value: Profile.manager.currentLocation,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.currentLocation = newValue ?? "";
                        });
                      },
                    ),
                    profileTextfield(
                      label: 'Hometown',
                      hintLabel: 'Enter Hometown',
                      textFieldIcon: Icons.home,
                      value: Profile.manager.hoemTown,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.hoemTown = newValue ?? "";
                        });
                      },
                    ),
                    profileTextfield(
                      label: 'College',
                      hintLabel: 'Enter College',
                      textFieldIcon: Icons.school,
                      value: Profile.manager.college,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.college = newValue ?? "";
                        });
                      },
                    ),
                    profileTextfield(
                      label: 'Job Title',
                      hintLabel: 'Enter Job Title',
                      textFieldIcon: Icons.home,
                      value: Profile.manager.jobTitle,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.jobTitle = newValue ?? "";
                        });
                      },
                    ),
                    profileDropdown(
                      label: 'Education',
                      value: Profile.manager.educationLevel,
                      dropdownIcon: Icons.school,
                      options: educationLevelList,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.educationLevel = newValue ?? "";
                        });
                      },
                    ),
                    profileDropdown(
                      label: 'MBTI',
                      value: Profile.manager.mbti,
                      dropdownIcon: Icons.person_add_outlined,
                      options: mbtiList,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.mbti = newValue ?? "Prefer not to say";
                        });
                      },
                    ),
                    profileDropdown(
                      label: 'Constellation',
                      value: Profile.manager.constellation,
                      dropdownIcon: Icons.star_outline,
                      options: constellationList,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.constellation = newValue ?? "Prefer not to say";
                        });
                      },
                    ),
                    profileDropdown(
                      label: 'Blood Type',
                      value: Profile.manager.bloodType,
                      dropdownIcon: Icons.water_drop_outlined,
                      options: bloodTypeList,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.bloodType = newValue ?? "Prefer not to say";
                        });
                      },
                    ),
                    profileDropdown(
                      label: 'Religion',
                      value: Profile.manager.religion,
                      dropdownIcon: Icons.public_outlined,
                      options: religionList,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.religion = newValue ?? "Prefer not to say";
                        });
                      },
                    ),
                    profileDropdown(
                      label: 'Sexuality',
                      value: Profile.manager.sexuality,
                      dropdownIcon: Icons.favorite_outline,
                      options: sexualityList,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.sexuality = newValue ?? "Prefer not to say";
                        });
                      },
                    ),
                    profileDropdown(
                      label: "Ethnicity",
                      value: Profile.manager.ethnicity,
                      dropdownIcon: Icons.group_outlined,
                      options: ethnicityList,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.ethnicity = newValue ?? "Prefer not to say";
                        });
                      },
                    ),
                    profileDropdown(
                      label: 'Diet',
                      value: Profile.manager.diet,
                      dropdownIcon: Icons.restaurant_menu_outlined,
                      options: dietList,
                      onChanged: (newValue) {
                        setState(() {
                          Profile.manager.diet = newValue ?? "Prefer not to say";
                        });
                      },
                    ),
                    ProfileMultiInput(
                      label: 'Personalities',
                      hintLabel: 'Enter personality',
                      icon: Icons.person,
                      values: Profile.manager.personalities,
                      onChanged: (newValues) {
                        setState(() {
                          Profile.manager.personalities = newValues;
                        });
                      },
                    ),
                    ProfileMultiInput(
                      label: 'Skills',
                      hintLabel: 'Enter skill',
                      icon: Icons.work,
                      values: Profile.manager.skills,
                      onChanged: (newValues) {
                        setState(() {
                          Profile.manager.skills = newValues;
                        });
                      },
                    ),
                    if(!isKeyboardVisible)const SizedBox(height: 100,) //避免下面預留的空間穿幫
                    
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
                            onPressed: () =>{
                              print(Profile.manager.skills),
                              print(Profile.manager.personalities), // 可能彥廷要幫我確認這樣ok不ok
                              Navigator.pushNamed(context, RouteMap.eventTypeProfilePage),
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
            ]
        ),
        ),
      ),
    );
  }
}
