import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/sparkUp_describe_container.dart';
import 'package:spark_up/common_widget/sparkUp_multiChooseWithOther.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:intl/intl.dart';

List<Step> createSportSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'What kind of exercise are you planning to do?'),
          SparkupSingleChoose(
            label: 'Sport Type',
            hintlabel:'Please select sport type',
            availableTags: sportType,
            onChanged: (selectedSport) {
              setState(() {
                basePost.attributes["Selected Sport"] = selectedSport;
                print(basePost.attributes);
              });
            },
          ),
          profileTextfield(
            label: 'Sports Rule',
            hintLabel: 'Enter rule',
            maxLine: 4,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Sports Rule"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Sports Rule"] = newValue ?? "";
              });
            },
          ),
          profileTextfield(
            label: 'Winning Prize',
            hintLabel: 'Enter Winning Prize',
            maxLine: 1,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Winning Prize"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Winning Prize"] = newValue ?? "";
              });
            },
          ),
          profileTextfield(
            label: 'Entry Fee',
            hintLabel: 'Enter Entry Fee',
            maxLine: 1,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Entry Fee"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Entry Fee"] = newValue ?? "";
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

          SizedBox(height: 16,),
          profileTextfield(
            label: 'Requirements of Participants',
            hintLabel: 'Enter requirements',
            maxLine: 4,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Requirements of Participants"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Requirements of Participants"] = newValue ?? "";
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
          profileTextfield(
            label: 'Notes',
            hintLabel: 'Enter requirements',
            maxLine: 5,
            textFieldIcon: 'assets/icons/user.svg',
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
