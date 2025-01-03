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
            label: 'Furniture and equipment',
            hintLabel: 'Enter something',
            values: basePost.attributes["Furniture and equipment"]?? [],
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Furniture and equipment"] = newValues;
            });
          },
          ),
          MultiInput(
            label: 'Amenities',
            hintLabel: 'Enter something',
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
              options: liveGenderList,
              onChanged: (newValue) {
                setState(() {
                  basePost.attributes["Gender"] = newValue;
                });
              },
              isRequired: true,
            ),
          Textfield(
            label: 'Personality',
            hintLabel: 'Enter personality',
            maxLine: 1,
            value: basePost.attributes[""] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Personality"] = newValue ?? "";
              });
            },
          ),
          Textfield(
            label: 'Lifestyle',
            hintLabel: 'Enter lifestyle',
            maxLine: 3,
            value: basePost.attributes["Lifestyle"] ?? "",
            onChanged: (newValue) {
              setState(() {
                basePost.attributes["Lifestyle"] = newValue ?? "";
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
            hintLabel: 'Enter your contact information',
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
            hintLabel: 'Enter security deposit',
            value: basePost.attributes["Security deposit"] ?? "",
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Security deposit"] = newValues ?? "";
            });
          },
          onlyNumber: true,
          ),
          Textfield(
            label: 'Rent(monthly)',
            hintLabel: 'Enter rent',
            value: basePost.attributes["Rent(monthly)"] ?? "",
          onChanged:(newValues) {
            setState(() {
              basePost.attributes["Rent(monthly)"] = newValues ?? "";
            });
          },
          onlyNumber: true,
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
            onlyNumber: true,
          )
        ],
      ),
      isActive: currentStep >= 4,
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
      isActive: currentStep >= 5,
    ),
  ];
}
