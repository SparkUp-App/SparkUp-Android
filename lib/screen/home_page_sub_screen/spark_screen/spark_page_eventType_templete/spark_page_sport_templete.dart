import 'package:flutter/material.dart';
import 'package:spark_up/data/base_post.dart';

List<Step> createSportSteps(int currentStep, BasePost basePost) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Enter home team name'),
            onChanged: (value) {
              basePost.location = value;
            },
            controller: TextEditingController(text: basePost.location),
          ),
        ],
      ),
      isActive: currentStep >= 2,
    ),
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          
        ],
      ),
      isActive: currentStep >= 3,
    ),
  ];
}