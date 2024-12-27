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
List<Step> createMealSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'Please introduce the restaurant and what its signature dishes are.'),
          Textfield(
            label: 'Restaurant name',
            hintLabel: 'Please desribe Restaurant name',
            maxLine: 1,
            value: basePost.attributes["Restaurant name"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Restaurant name"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Signature dishes',
            hintLabel: 'Please desribe  Signature dishes',
            maxLine: 1,
            value: basePost.attributes["Signature dishes"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Signature dishes"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Link of the restaurant',
            hintLabel: 'Link of the restaurant',
            maxLine: 1,
            value: basePost.attributes["Link of the restaurant"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Link of the restaurant"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Intro of the restaurant',
            hintLabel: 'Please desribe Intro of the restaurants',
            maxLine: 4,
            value: basePost.attributes["Intro of the restaurant"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Intro of the restaurant"] = newValue ?? "";
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
          NoteCard(message: "What are the participation guidelines that participants need to know? "),
          Textfield(
            label: 'Participation guidelines',
            hintLabel: 'Enter Participation guidelines',
            maxLine: 4,
            value: basePost.attributes["Participation guidelines"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Participation guidelines"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Price',
            hintLabel: 'Enter Entry fee',
            maxLine: 1,
            value: basePost.attributes["Price"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Price"] = newValue ?? "";
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

