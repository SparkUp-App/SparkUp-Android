import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/profile_MultiTextField.dart';
import 'package:spark_up/common_widget/sparkUp_describe_container.dart';
import 'package:spark_up/common_widget/sparkUp_multiChooseWithOther.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:intl/intl.dart';

List<Step> createCompetitionSteps(int currentStep, BasePost basePost, Function setState) {
  List<String> tmp = [];
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'Briefly explain the rules need to be follow and how to win this competition.'),
          profileTextfield(
            label: 'Rule',
            hintLabel: 'Please desribe the rules',
            maxLine: 4,
            textFieldIcon: 'assets/icons/user.svg',
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
      isActive: currentStep >= 3,
    ),
    Step(
      
      title: const SizedBox.shrink(),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NoteCard(message: "A well prize can appeal more people to participant your competition."),
          ProfileMultiInput(
            label: 'Prize',
            hintLabel: 'Enter Entry Prizes',
            icon: 'assets/icons/user.svg',
            values: tmp, 
          onChanged:(newValues) {
            setState(() {
              tmp = newValues;
              basePost.attributes["Prize"] = tmp;
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
      isActive: currentStep >= 5,
    ),
  ];
}
