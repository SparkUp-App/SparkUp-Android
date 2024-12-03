import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_dropdown.dart';
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
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_dropdown.dart';
import 'package:spark_up/const_variable.dart';

List<Step> createRoommateSteps(int currentStep, BasePost basePost, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: 'Please give us an introduction about your place.'),
          CustomDropdown(
              label: 'Type',
              value: basePost.attributes["Type"],
              options: liveList,
              onChanged: (newValue) {
                setState(() {
                  basePost.attributes["Type"] = newValue;
                  print(newValue);
                });
              },
              isRequired: true,
            ),
          Textfield(
            label: 'Address',
            hintLabel: 'Please desribe the Address',
            maxLine: 1,
            value: basePost.attributes["Address"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Address"] = newValue ?? "";
              });
            },
          ),
          MultiInput(
            label: 'Furniture and Equipment',
            hintLabel: 'Enter Entry some of it',
            values: basePost.attributes["Furniture and Equipment"]?? [],
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Furniture and Equipment"] = newValues;
            });
          },
          ),
          MultiInput(
            label: 'Amenities',
            hintLabel: 'Enter Entry some of it',
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
          CustomDropdown(
              label: 'Gender',
              value: basePost.attributes["Gender"],
              options: genderList,
              onChanged: (newValue) {
                setState(() {
                  basePost.attributes["Gender"] = newValue;
                });
              },
              isRequired: true,
            ),
          Textfield(
            label: 'Personality',
            hintLabel: 'Enter Personality',
            maxLine: 1,
            value: basePost.attributes[""] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Personality"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'lifestyle',
            hintLabel: 'Enter lifestyle',
            maxLine: 3,
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
          Textfield(
            label: 'Your contact information',
            hintLabel: 'Enter Your contact information',
            value: basePost.attributes["Your contact information"] ?? "",
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Your contact information"] = newValues ?? "";
            });
          },
          ),
          Datepicker(
            label: "Move-in date", 
            value: basePost.attributes["Move-in date"] ?? "",
            onChanged: (newValues) {
            setState(() {
              basePost.attributes["Move-in date"] = newValues ?? "";
            });
          },
          ),
          Textfield(
            label: 'Security deposit',
            hintLabel: 'Enter Security deposit',
            value: basePost.attributes["Security deposit"] ?? "",
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Security deposit"] = newValues ?? "";
            });
          },
          ),
          Textfield(
            label: 'Rent(monthly)',
            hintLabel: 'Enter Security deposit',
            value: basePost.attributes["Rent(monthly)"] ?? "",
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Rent(monthly)"] = newValues ?? "";
            });
          },
          ),
          DoubleTextFieldToMakeMap(
            label: "MISC", 
            firstHintLabel: "Item", 
            secondHintLabel: "Amount", 
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
      isActive: currentStep >= 5,
    ),
  ];
}
