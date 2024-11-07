import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/profile_DatePicker.dart';
import 'package:spark_up/common_widget/profile_MultiTextField.dart';
import 'package:spark_up/common_widget/sparkUp_describe_container.dart';
import 'package:spark_up/common_widget/sparkUp_multiChooseWithOther.dart';
import 'package:spark_up/common_widget/sparkUp_multiTextFieldMap.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:intl/intl.dart';

List<Step> createSpeechSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'What is the topic of your speech this time?  Who will be the speaker?'),
          profileTextfield(
            label: 'Topic',
            hintLabel: 'Please desribe Topic',
            maxLine: 1,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Topic"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Topic"] = newValue ?? "";
              });
            },
          ),
          profileTextfield(
            label: '',
            hintLabel: 'Please desribe Speaker',
            maxLine: 1,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Speaker"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Speaker"] = newValue ?? "";
              });
            },
          ),
          profileTextfield(
            label: 'Introduce the Topic',
            hintLabel: 'Please desribe Introduce the Topic',
            maxLine: 5,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Introduce the Topic"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Introduce the Topic"] = newValue ?? "";
              });
            },
          ),
          profileTextfield(
            label: 'Entry fee (optional)',
            hintLabel: 'Enter Entry fee',
            maxLine: 1,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Entry fee"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Entry fee"] = newValue ?? "";
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NoteCard(message: "What kind of participants are you looking for ?"),
          profileTextfield(
            label: 'Requirements for Participants',
            hintLabel: 'Enter Requirements for Participants',
            maxLine: 4,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Requirements for Participants"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Requirements for Participants"] = newValue ?? "";
              });
            },
          ),
        ],
      ),
      isActive: currentStep >= 3,
    ),
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: "Finally, is there anything you would like to share that we haven't mentioned previously?A"),
          profileTextfield(
            label: 'Notes',
            hintLabel: 'Enter anything you want to share that we have not mentioned previously',
            maxLine: 5,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.content ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.content = newValue ?? "";
              });
            },
          ),
        ],
      ),
      isActive: currentStep >= 4,
    ),
  ];
}
