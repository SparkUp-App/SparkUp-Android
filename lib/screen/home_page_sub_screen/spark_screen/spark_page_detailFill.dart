import 'package:flutter/material.dart';
import "package:spark_up/const_variable.dart";
import "package:spark_up/data/base_post.dart";
import "package:spark_up/network/network.dart";
import "package:spark_up/network/path/post_path.dart";
import "package:toasty_box/toast_enums.dart";
import "package:toasty_box/toasty_box.dart";
import "package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_templete/spark_page_sport_templete.dart";
import 'package:spark_up/common_widget/profile_Textfield.dart'; // 建立 common_widget
import 'package:spark_up/common_widget/profile_DatePicker.dart'; // 建立 common_widget
import 'package:spark_up/common_widget/profile_DropDown.dart'; // 建立 common_widget

class NextPage extends StatefulWidget {
  final String selectedEventType;

  const NextPage({Key? key, required this.selectedEventType}) : super(key: key);

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int _currentStep = 0;
  late List<Step> steps; // Store the dynamically generated steps
  BasePost basePost = BasePost.initfromDefaule(Network.manager.userId!);

  @override
  void initState() {
    super.initState();
    basePost.type = widget.selectedEventType;
    // Initial steps
    steps = getSteps(widget.selectedEventType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Event: ${widget.selectedEventType}'),
      ),
      body: Stepper(
        type: StepperType.horizontal, // Horizontal display
        currentStep: _currentStep,
        onStepContinue: _currentStep < steps.length - 1
            ? () {
                setState(() {
                  _currentStep += 1;
                  steps = getSteps(widget.selectedEventType); // Update steps
                });
              }
            : null,
        onStepCancel: _currentStep > 0
            ? () {
                setState(() {
                  _currentStep -= 1;
                  steps = getSteps(widget.selectedEventType); // Update steps
                });
              }
            : null,
        steps: steps,
      ),
    );
  }

  List<Step> getSteps(String eventType) {
    // Each event needs this content
    List<Step> steps = [
      Step(
        title: const SizedBox.shrink(), // No title
        content: Column(
          children: [
            profileTextfield(
              isRequired: true,
              label: "Title",
              hintLabel: "Enter Title Here",
              textFieldIcon: 'assets/icons/phone.svg',
              value: basePost.title,
              onChanged: (newValue) {
                setState(() {
                  basePost.title = newValue ?? "";
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Enter description'),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const SizedBox.shrink(), // No title
        content: Column(
          children: const [
            TextField(
              decoration: InputDecoration(labelText: 'Enter date'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Enter time'),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
    ];

    // Dynamically update templates
    switch (eventType) {
      case 'Sport':
        steps.addAll(createTeamAndLocationSteps(_currentStep));
        break;
      default:
        steps.add(
          Step(
            title: const SizedBox.shrink(), // No title
            content: Column(
              children: [
                Text('No specific details for this event type: ${basePost.type}.'),
              ],
            ),
            isActive: _currentStep >= 2,
          ),
        );
        break;
    }
    return steps;
  }
}
