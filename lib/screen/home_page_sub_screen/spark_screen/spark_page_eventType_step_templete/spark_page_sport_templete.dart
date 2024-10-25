import 'package:flutter/material.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:intl/intl.dart';

List<Step> createSportSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          profileTextfield(
            label: 'Sports Rule',
            hintLabel: 'Enter rule',
            maxLine: 4,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Sports Rule"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Sports Rule"] = newValue ?? "";
              });
            },
          ),
          profileTextfield(
            label: 'Requirements of Participants',
            hintLabel: 'Enter requirements',
            maxLine: 4,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Requirements of Participants"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Requirements of Participants"] = newValue ?? "";
              });
            },
          ),
        ],
      ),
      isActive: currentStep >= 2,
    ),
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          profileTextfield(
            label: 'Winning Prize',
            hintLabel: 'Enter Winning Prize',
            maxLine: 4,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Winning Prize"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Winning Prize"] = newValue ?? "";
              });
            },
            
          ),
        ],
      ),
      isActive: currentStep >= 3,
    ),
  ];
}
