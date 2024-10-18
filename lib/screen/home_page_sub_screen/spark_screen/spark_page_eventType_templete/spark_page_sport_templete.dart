import 'package:flutter/material.dart';

List<Step> createTeamAndLocationSteps(int currentStep) {
  return [
    Step(
      title: const SizedBox.shrink(), // No title,
      content: Column(
        children: const [
          TextField(
            decoration: InputDecoration(labelText: 'Enter team names'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Enter location'),
          ),
        ],
      ),
      isActive: currentStep >= 2,
    ),
    Step(
      title: const SizedBox.shrink(), // No title,
      content: Column(
        children: const [
          TextField(
            decoration: InputDecoration(labelText: 'Enter referee names'),
          ),
        ],
      ),
      isActive: currentStep >= 3,
    ),
  ];
}