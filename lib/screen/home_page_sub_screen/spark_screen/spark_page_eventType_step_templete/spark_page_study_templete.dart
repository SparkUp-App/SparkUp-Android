import 'package:flutter/material.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:intl/intl.dart';

List<Step> createStudySteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          profileTextfield(
            label: 'Kind of study circle',
            hintLabel: 'Enter rule',
            maxLine: 4,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Kind of study circle"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Kind of study circle"] = newValue ?? "";
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
            label: 'Study Goal',
            hintLabel: 'Enter Study Goal',
            maxLine: 4,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Study Goal"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Study Goal"] = newValue ?? "";
              });
            },
          ),
        ],
      ),
      isActive: currentStep >= 3,
    ),
  ];
}
