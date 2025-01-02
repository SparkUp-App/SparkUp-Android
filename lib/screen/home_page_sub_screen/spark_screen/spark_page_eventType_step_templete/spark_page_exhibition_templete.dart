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
List<Step> createExhibitionSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'Please give a brief introduction to the exhibition.'),
          Textfield(
            label: 'Introduction of this exhibition',
            hintLabel: 'Please introduction',
            maxLine: 5,
            value: basePost.attributes["Introduction"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Introduction"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Ticket price',
            hintLabel: 'Enter ticket price',
            maxLine: 5,
            value: basePost.attributes["Ticket price"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Ticket price"] = newValue ?? "";
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
      isActive: currentStep >= 3,
    ),
  ];
}
