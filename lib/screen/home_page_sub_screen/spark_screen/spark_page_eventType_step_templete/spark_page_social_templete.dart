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
List<Step> createSocialSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'Please briefly introduce your activity.'),
          Textfield(
            label: 'Your activity',
            hintLabel: 'Please desribe Your activity',
            maxLine: 5,
            value: basePost.attributes["Your activity"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Your activity"] = newValue ?? "";
              });
            },
          ),
          DoubleTextFieldToMakeMap(
            label: "Activity schedule", 
            firstHintLabel: "Time", 
            secondHintLabel: "Activity", 
            values: basePost.attributes["Activity schedule"] ?? {}, 
            onChanged:(newValues) {
              setState(() {
                basePost.attributes["Activity schedule"] = newValues;
              });
            },
          )
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
            hintLabel: 'Enter requirements for participants',
            maxLine: 4,
            value: basePost.attributes["Requirements for participants"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Requirements for participants"] = newValue ?? "";
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
