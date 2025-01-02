import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/profile_MultiTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_describe_container.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiChooseWithOther.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:intl/intl.dart';

import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_singleTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiTextField.dart';

List<Step> createCompetitionSteps(int currentStep, BasePost basePost, Function setState) {
  
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'Briefly explain the rules need to be follow and how to win this competition.'),
          Textfield(
            label: 'Rules',
            hintLabel: 'Please desribe the rules',
            maxLine: 4,
            value: basePost.attributes["Rules"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Rules"] = newValue ?? "";
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
          Textfield(
            label: 'Requirements of participants',
            hintLabel: 'Enter requirements',
            maxLine: 4,
            value: basePost.attributes["Requirements of participants"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Requirements of participants"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Entry fee',
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NoteCard(message: "A well prize can appeal more people to participant your competition."),
          MultiInput(
            label: 'Prizes',
            hintLabel: 'Enter entry prizes',
            values:  basePost.attributes["Prizes"] ?? [],
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Prizes"] = newValues;
            });
          },
          )
        ],
      ),
      isActive: currentStep >= 4,
    ),
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: "Anything you would like to add to the participants"),
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
      isActive: currentStep >= 5,
    ),
  ];
}
