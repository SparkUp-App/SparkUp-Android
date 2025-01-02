import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_describe_container.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:intl/intl.dart';

import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_singleTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_datePicker.dart';
List<Step> createStudySteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: "What is the topic of your study? It can be a book or an issue."),
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
            label: 'Introduction of the topic',
            hintLabel: 'Enter introduction',
            maxLine: 4,
            value: basePost.attributes["Introduction of the topic"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Introduction of the topic"] = newValue ?? "";
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
          NoteCard(message: "What are the participation guidelines that participants need to know?"),
          Textfield(
            label: 'Participation guidelines',
            hintLabel: 'Enter guidelines',
            maxLine: 1,
            value: basePost.attributes["Participation guidelines"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Participation guidelines"] = newValue ?? "";
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
  isActive: currentStep >= 4,
),
  ];
}
