import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/sparkUp_describe_container.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:spark_up/common_widget/sparkUp_multiDate_input.dart';
import 'package:intl/intl.dart';

List<Step> createTravelSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: "Please briefly introduce your travel."),
          profileTextfield(
            label: 'Introduce',
            hintLabel: 'Enter Introduce',
            maxLine: 5,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Introduce"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Introduce"] = newValue ?? "";
              });
            },
          ),
          profileTextfield(
            label: 'Price',
            hintLabel: 'Enter Price',
            maxLine: 1,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Price"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Price"] = newValue ?? "";
              });
            },
          ),
          profileTextfield(
            label: 'Participation guidelines',
            hintLabel: 'Enter Participation guidelines',
            maxLine: 1,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Participation guidelines"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Participation guidelines"] = newValue ?? "";
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
          NoteCard(message: "Please fill in the destination according to the order of the travel itinerary."),
          TopicMultiInput(
            topicsData: basePost.attributes["Itinerary"] ?? <String, List<String>>{},
            onChanged: (Map<String, List<String>> newData) {
               basePost.attributes["Itinerary"] = newData;
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
       
 
          
          
