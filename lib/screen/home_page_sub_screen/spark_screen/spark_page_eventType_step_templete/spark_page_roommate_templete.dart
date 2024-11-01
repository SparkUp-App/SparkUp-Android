import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/profile_DatePicker.dart';
import 'package:spark_up/common_widget/profile_MultiTextField.dart';
import 'package:spark_up/common_widget/sparkUp_describe_container.dart';
import 'package:spark_up/common_widget/sparkUp_multiChooseWithOther.dart';
import 'package:spark_up/common_widget/sparkUp_multiTextFieldMap.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:intl/intl.dart';

List<Step> createRoommateSteps(int currentStep, BasePost basePost, Function setState) {
  List<String> tmp = [];
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'Please give us an introduction about your place.'),
          profileTextfield(
            label: 'Type',
            hintLabel: 'Please desribe the type',
            maxLine: 1,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Type"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Type"] = newValue ?? "";
              });
            },
          ),
          profileTextfield(
            label: 'Address',
            hintLabel: 'Please desribe the Address',
            maxLine: 1,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Address"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Address"] = newValue ?? "";
              });
            },
          ),
          ProfileMultiInput(
            label: 'Furniture and Equipment',
            hintLabel: 'Enter Entry some of it',
            icon: 'assets/icons/user.svg',
            values: basePost.attributes["Furniture and Equipment"]?? [],
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Furniture and Equipment"] = newValues;
            });
          },
          ),
          ProfileMultiInput(
            label: 'Amenities',
            hintLabel: 'Enter Entry some of it',
            icon: 'assets/icons/user.svg',
            values: basePost.attributes["Amenities"]?? [],
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Amenities"] = newValues;
            });
          },
          )
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
          NoteCard(message: "What kind of roommate are you looking for ?"),
          profileTextfield(
            label: 'Gender',
            hintLabel: 'Enter Gender',
            maxLine: 1,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Gender"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Gender"] = newValue ?? "";
              });
            },
          ),
          profileTextfield(
            label: 'Personality',
            hintLabel: 'Enter Personality',
            maxLine: 1,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes[""] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Personality"] = newValue ?? "";
              });
            },
          ),
          profileTextfield(
            label: 'lifestyle',
            hintLabel: 'Enter lifestyle',
            maxLine: 3,
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["lifestyle"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["lifestyle"] = newValue ?? "";
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
          NoteCard(message: "Such a fascinating place must come with some cost."),
          profileTextfield(
            label: 'Your contact information',
            hintLabel: 'Enter Your contact information',
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Your contact information"] ?? "",
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Your contact information"] = newValues ?? "";
            });
          },
          ),
          profieldDatepicker(
            label: "Move-in date", 
            value: basePost.attributes["Move-in date"] ?? "",
            datepickerIcon: 'assets/icons/user.svg',
            onChanged: (newValues) {
            setState(() {
              basePost.attributes["Move-in date"] = newValues ?? "";
            });
          },
          ),
          profileTextfield(
            label: 'Security deposit',
            hintLabel: 'Enter Security deposit',
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Security deposit"] ?? "",
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Security deposit"] = newValues ?? "";
            });
          },
          ),
          profileTextfield(
            label: 'Rent(monthly)',
            hintLabel: 'Enter Security deposit',
            textFieldIcon: 'assets/icons/user.svg',
            value: basePost.attributes["Rent(monthly)"] ?? "",
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Rent(monthly)"] = newValues ?? "";
            });
          },
          ),
          ProfileDoubleTextFieldToMakeMap(
            label: "MISC", 
            firstHintLabel: "Type", 
            secondHintLabel: "Type to do", 
            icon: 'assets/icons/user.svg', 
            values: basePost.attributes["MISC"] ?? {}, 
            onChanged:(newValues) {
              setState(() {
                basePost.attributes["MISC"] = newValues;
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
          NoteCard(message: "Finally, is there anything you would like to share that we haven't mentioned previously?A"),
          profileTextfield(
            label: 'Notes',
            hintLabel: 'Enter anything you want to share that we have not mentioned previously',
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
