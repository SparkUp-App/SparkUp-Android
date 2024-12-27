import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_describe_container.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_int_counter.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiTopic_input.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_singleTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_datePicker.dart';
List<Step> createBaseInfoStep(int currentStep, BasePost basePost, double screenSize, BuildContext context, Function setState) {
  return [
    Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          NoteCard(message: "First, let’s decide some basic information for your activity."),
          
          SizedBox(height: 16,),
          Textfield(
            label: "Title",
            hintLabel: "Enter Title Here",
            value: basePost.title,
            onChanged: (newValue) => setState(() => basePost.title = newValue ?? ""),
            isRequired: true,
            restrictWord: 30,
          ),
          Textfield(
            label: "Location",
            hintLabel: "Enter Location Here",
            value: basePost.location,
            onChanged: (newValue) => setState(() => basePost.location = newValue ?? ""),
            isRequired: true,
          ),
          intCounterBox(
            label: "Number of people",
            isRequired: true,
            minValue: 1,
            maxValue: 100,
            initialValue: 4,
            onChanged: (newValue) {
              basePost.numberOfPeopleRequired = newValue.toInt();
            },
          ),
          // 修改這裡的日期時間選擇器邏輯
          _buildDatePicker(
            label: "Event Start Date",
            date: basePost.eventStartDate,
            onDateChanged: (date) => setState(() {
              basePost.eventStartDate = DateTime(
                date.year,
                date.month,
                date.day,
                basePost.eventStartDate.hour,
                basePost.eventStartDate.minute,
              );
            }),
            screenSize: screenSize,
            context: context,
          ),
          _buildTimePicker(
            label: "Event Start Time",
            time: TimeOfDay.fromDateTime(basePost.eventStartDate),
            onTimeChanged: (time) => setState(() {
              basePost.eventStartDate = DateTime(
                basePost.eventStartDate.year,
                basePost.eventStartDate.month,
                basePost.eventStartDate.day,
                time.hour,
                time.minute,
              );
            }),
            screenSize: screenSize,
            context: context,
          ),
          _buildDatePicker(
            label: "Event End Date",
            date: basePost.eventEndDate,
            onDateChanged: (date) => setState(() {
              basePost.eventEndDate = DateTime(
                date.year,
                date.month,
                date.day,
                basePost.eventEndDate.hour,
                basePost.eventEndDate.minute,
              );
            }),
            screenSize: screenSize,
            context: context,
          ),
          _buildTimePicker(
            label: "Event End Time",
            time: TimeOfDay.fromDateTime(basePost.eventEndDate),
            onTimeChanged: (time) => setState(() {
              basePost.eventEndDate = DateTime(
                basePost.eventEndDate.year,
                basePost.eventEndDate.month,
                basePost.eventEndDate.day,
                time.hour,
                time.minute,
              );
            }),
            screenSize: screenSize,
            context: context,
          ),
        ],
      ),
      isActive: currentStep >= 0,
    ),
  ];
}

Widget _buildDatePicker({
  required String label,
  required DateTime date,
  required Function(DateTime) onDateChanged,
  required double screenSize,
  required BuildContext context,
}) {
  // 創建一個 controller 並設置初始值
  final TextEditingController controller = TextEditingController(
    text: "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
  );

  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label *",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFE9765B),
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              width: screenSize * 0.75,
              child: InkWell(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(9999),
                  );
                  if (selectedDate != null) {
                    controller.text = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                    onDateChanged(selectedDate);
                  }
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: controller,  // 使用我們創建的 controller
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE9765B)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE9765B)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE9765B)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: const Icon(Icons.calendar_today),
                      prefixIconColor: Colors.black26,
                      hintText: "yyyy-mm-dd",
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildTimePicker({
  required String label,
  required TimeOfDay time,
  required Function(TimeOfDay) onTimeChanged,
  required double screenSize,
  required BuildContext context,
}) {
  // 創建一個 controller 並設置初始值
  final TextEditingController controller = TextEditingController(
    text: time.format(context)
  );

  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label *",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFE9765B),
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              width: screenSize * 0.75,
              child: InkWell(
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );
                  if (selectedTime != null) {
                    // 更新 controller 的值
                    controller.text = selectedTime.format(context);
                    onTimeChanged(selectedTime);
                  }
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: controller,  // 使用我們創建的 controller
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE9765B)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE9765B)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE9765B)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: const Icon(Icons.access_time),
                      prefixIconColor: Colors.black26,
                      hintText: "hh:mm",
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}