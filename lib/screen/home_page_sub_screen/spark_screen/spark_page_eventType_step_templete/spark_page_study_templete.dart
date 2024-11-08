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
            label: 'Kind of study topic',
            hintLabel: 'Enter topic',
            maxLine: 1,
            value: basePost.attributes["Kind of study topic"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Kind of study topic"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Introduce the Topic',
            hintLabel: 'Enter introduce',
            maxLine: 4,
            value: basePost.attributes["Introduce the Topic"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Introduce the Topic"] = newValue ?? "";
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
            label: 'Participation Guidelines',
            hintLabel: 'Enter Guidelines',
            maxLine: 1,
            value: basePost.attributes["Participation Guidelines"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Participation Guidelines"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Entry Fee',
            hintLabel: 'Enter Entry Fee',
            maxLine: 1,
            value: basePost.attributes["Entry Fee"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Entry Fee"] = newValue ?? "";
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
      NoteCard(message: "Anything you would like to add to the participants"),
      Textfield(
        label: 'Notes',
        hintLabel: 'Enter requirements',
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
