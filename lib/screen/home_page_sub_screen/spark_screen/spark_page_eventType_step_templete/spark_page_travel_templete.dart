import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_describe_container.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiDate_input.dart';
import 'package:intl/intl.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_singleTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_datePicker.dart';
List<Step> createTravelSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: "Please briefly introduce your travel."),
          Textfield(
            label: 'Introduction',
            hintLabel: 'Enter introduction',
            maxLine: 5,
            value: basePost.attributes["introduction"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["introduction"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Price',
            hintLabel: 'Enter price',
            maxLine: 1,
            value: basePost.attributes["Price"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Price"] = newValue ?? "";
              });
            },
            onlyNumber: true,
          ),
          Textfield(
            label: 'Participation guidelines',
            hintLabel: 'Enter guidelines',
            maxLine: 5,
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
       
 
          
          
