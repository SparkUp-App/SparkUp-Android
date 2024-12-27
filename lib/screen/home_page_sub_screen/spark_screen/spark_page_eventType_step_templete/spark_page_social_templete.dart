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
            label: "Activity Schedule", 
            firstHintLabel: "Time", 
            secondHintLabel: "Schedule", 
            values: basePost.attributes["Activity Schedule"] ?? {}, 
            onChanged:(newValues) {
              setState(() {
                basePost.attributes["Activity Schedule"] = newValues;
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
            label: 'Requirements for Participants',
            hintLabel: 'Enter Requirements for Participants',
            maxLine: 4,
            value: basePost.attributes["Requirements for Participants"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Requirements for Participants"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Entry fee (optional)',
            hintLabel: 'Enter Entry fee',
            maxLine: 1,
            value: basePost.attributes["Entry fee"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Entry fee"] = newValue ?? "";
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
            hintLabel: 'Enter anything you want to share that we have not mentioned previously',
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
