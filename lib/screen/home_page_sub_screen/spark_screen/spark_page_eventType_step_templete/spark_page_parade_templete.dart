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
List<Step> createParadeSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'Please briefly introduce your parade.'),
          Textfield(
            label: 'Introduction of this parade',
            hintLabel: 'Please introduce',
            maxLine: 5,
            value: basePost.attributes["Introduce"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Introduce"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Address',
            hintLabel: 'Enter address',
            maxLine: 1,
            value: basePost.attributes["Address"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Address"] = newValue ?? "";
              });
            },
          ),
          MultiInput(
            label: 'Parade route',
            hintLabel: 'Enter parade route',
            values: basePost.attributes["Parade route"]?? [],
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Parade route"] = newValues;
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
            hintLabel: 'Enter participation guidelines',
            maxLine: 1,
            value: basePost.attributes["Participation guidelines"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Participation guidelines"] = newValue ?? "";
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
