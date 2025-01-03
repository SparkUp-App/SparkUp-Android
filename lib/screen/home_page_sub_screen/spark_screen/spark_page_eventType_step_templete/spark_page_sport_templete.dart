import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_describe_container.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiChooseWithOther.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:intl/intl.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_singleTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_datePicker.dart';
List<Step> createSportSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'What kind of exercise are you planning to do?'),
          SparkupSingleChoose(
            label: 'Sport type',
            hintlabel:'Please select sport type',
            availableTags: sportType,
            onChanged: (selectedSport) {
              setState(() {
                basePost.attributes["Selected sport"] = selectedSport;
                print(basePost.attributes);
              });
            },
          ),
          Textfield(
            label: 'Rule',
            hintLabel: 'Enter rule',
            maxLine: 4,
            value: basePost.attributes["Rule"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Rule"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Prize',
            hintLabel: 'Enter prize',
            maxLine: 1,
            value: basePost.attributes["Winning prize"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Winning prize"] = newValue ?? "";
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
      isActive: currentStep >= 2,
    ),
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NoteCard(message: "What kind of participants are you looking for ?"),

          SizedBox(height: 16,),
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
