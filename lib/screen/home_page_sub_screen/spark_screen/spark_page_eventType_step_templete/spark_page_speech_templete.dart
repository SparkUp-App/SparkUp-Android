import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/profile_DatePicker.dart';
import 'package:spark_up/common_widget/profile_MultiTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_describe_container.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiChooseWithOther.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiTextFieldMap.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:intl/intl.dart';

import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_singleTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_datePicker.dart';

List<Step> createSpeechSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'What is the topic of your speech this time?  Who will be the speaker?'),
          Textfield(
            label: 'Topic',
            hintLabel: 'Enter topic',
            maxLine: 1,
            value: basePost.attributes["Topic"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Topic"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Speaker',
            hintLabel: 'Enter speaker',
            maxLine: 1,
            value: basePost.attributes["Speaker"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Speaker"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Introduction of the topic',
            hintLabel: 'Enter introduction',
            maxLine: 5,
            value: basePost.attributes["Introduce the Topic"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Introduce the Topic"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Entry fee (optional)',
            hintLabel: 'Enter entry fee',
            maxLine: 1,
            value: basePost.attributes["Entry fee"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Entry fee"] = newValue ?? "";
              });
            },
            onlyNumber: true,
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
          Textfield(
            label: 'Requirements for participants',
            hintLabel: 'Enter requirements',
            maxLine: 4,
            value: basePost.attributes["Requirements for participants"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Requirements for participants"] = newValue ?? "";
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
          NoteCard(message: "Finally, is there anything you would like to share that we haven't mentioned previously?"),
          Textfield(
            label: 'Notes',
            hintLabel: 'Enter notes',
            maxLine: 5,
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
