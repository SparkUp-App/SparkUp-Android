import "package:flutter/material.dart";
import "package:spark_up/common_widget/profile_DatePicker.dart";
import "package:spark_up/common_widget/profile_DropDown.dart";
import "package:spark_up/common_widget/profile_Textfield.dart";
import "package:spark_up/common_widget/system_message.dart";
import "package:spark_up/const_variable.dart";
import "package:spark_up/data/base_post.dart";
import "package:spark_up/network/network.dart";
import "package:spark_up/network/path/post_path.dart";
import "package:toasty_box/toast_enums.dart";
import "package:toasty_box/toasty_box.dart";

class SparkPage extends StatefulWidget {
  const SparkPage({super.key});

  @override
  State<SparkPage> createState() => _SparkPageState();
}

class _SparkPageState extends State<SparkPage> {
  BasePost basePost = BasePost.initfromDefaule(Network.manager.userId!);
  final double marginVertical = 10.0, marginHorizontal = 20.0;
  DateTime eventStartDate = DateTime.now(), eventEndDate = DateTime.now();
  TimeOfDay eventStartTime = TimeOfDay(hour: 0, minute: 0),
      eventEndTime = TimeOfDay(hour: 0, minute: 0);
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("SparkUP!!")),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30.0,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: marginVertical, horizontal: marginHorizontal),
              child: profileDropdown(
                  isRequired: true,
                  label: "Type",
                  value: null,
                  dropdownIcon: Icons.view_timeline,
                  options: eventType,
                  onChanged: (newValue) {
                    setState(() {
                      basePost.type = newValue ?? "";
                    });
                  }),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: marginVertical, horizontal: marginHorizontal),
              child: profileTextfield(
                  isRequired: true,
                  label: "Title",
                  hintLabel: "Enter Title Here",
                  textFieldIcon: Icons.title,
                  value: basePost.title,
                  onChanged: (newValue) {
                    setState(() {
                      basePost.title = newValue ?? "";
                    });
                  }),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: marginVertical, horizontal: marginHorizontal),
              child: profileTextfield(
                  isRequired: true,
                  label: "Content",
                  hintLabel: "Enter Content Here",
                  textFieldIcon: Icons.edit_note,
                  value: basePost.content,
                  onChanged: (newValue) {
                    setState(() {
                      basePost.content = newValue ?? "";
                    });
                  }),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: marginVertical),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Number of People Requried *", //Require 要多顯示 * 號
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFE9765B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFFE9765B)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFFE9765B)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFFE9765B)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.people),
                            prefixIconColor: Colors.black26,
                            hintText: "Enter Number",
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              basePost.numberOfPeopleRequired =
                                  int.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    vertical: marginVertical, horizontal: marginHorizontal),
                child: profileTextfield(
                    isRequired: true,
                    label: "Location",
                    hintLabel: "Enter Location Here",
                    textFieldIcon: Icons.location_on,
                    value: basePost.location,
                    onChanged: (newValue) {
                      setState(() {
                        basePost.location = newValue ?? "";
                      });
                    })),
            Container(
              // Start Date Picker
              margin: EdgeInsets.symmetric(
                  vertical: marginVertical, horizontal: marginHorizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Event Start Date *", //Require 要多顯示 * 號
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFE9765B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: InkWell(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(9999),
                            );

                            if (selectedDate != null) {
                              setState(() {
                                eventStartDate = selectedDate;
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: TextField(
                              controller: TextEditingController(
                                  text: eventStartDate
                                      .toIso8601String()
                                      .split("T")[0]),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
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
            ),
            Container(
              // Start Time Picker
              margin: EdgeInsets.symmetric(
                  vertical: marginVertical, horizontal: marginHorizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Event Start Time *", //Require 要多顯示 * 號
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFE9765B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: InkWell(
                          onTap: () async {
                            TimeOfDay? selectedTime = await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 0, minute: 0));

                            if (selectedTime != null) {
                              setState(() {
                                eventStartTime = selectedTime;
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: TextField(
                              controller: TextEditingController(
                                  text: eventStartTime.format(context)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: const Icon(Icons.calendar_today),
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
            ),
            Container(
              // End Date Picker
              margin: EdgeInsets.symmetric(
                  vertical: marginVertical, horizontal: marginHorizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Event End Date *", //Require 要多顯示 * 號
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFE9765B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: InkWell(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: eventStartDate,
                              firstDate: eventStartDate,
                              lastDate: DateTime(9999),
                            );

                            if (selectedDate != null) {
                              setState(() {
                                eventEndDate = selectedDate;
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: TextField(
                              controller: TextEditingController(
                                  text: eventEndDate
                                      .toIso8601String()
                                      .split("T")[0]),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
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
            ),
            Container(
              // End Time Picker
              margin: EdgeInsets.symmetric(
                  vertical: marginVertical, horizontal: marginHorizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Event End Time *", //Require 要多顯示 * 號
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFE9765B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: InkWell(
                          onTap: () async {
                            TimeOfDay? selectedTime = await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 0, minute: 0));

                            if (selectedTime != null) {
                              setState(() {
                                eventEndTime = selectedTime;
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: TextField(
                              controller: TextEditingController(
                                  text: eventEndTime.format(context)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE9765B)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: const Icon(Icons.calendar_today),
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
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Center(
                child: TextButton(
                  child: const Text("Create Event"),
                  onPressed: () => createEvent(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void createEvent() async {
    DateTime start = DateTime(eventStartDate.year, eventEndDate.month,
        eventStartDate.day, eventStartTime.hour, eventStartTime.minute);
    DateTime end = DateTime(eventEndDate.year, eventEndDate.month,
        eventEndDate.day, eventEndTime.hour, eventEndTime.minute);

    if (basePost.type.isEmpty ||
        basePost.title.isEmpty ||
        basePost.content.isEmpty ||
        basePost.location.isEmpty) {
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "Please fill in all required fields.",
      );
      return;
    } else if (basePost.numberOfPeopleRequired.isNegative ||
        basePost.numberOfPeopleRequired == 0) {
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message:
              "Please fill the correct interger of number of people requried.");
    } else if (start.isAfter(end)) {
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Event start time most before Event end time");
    }

    setState(() {
      isLoading = true;
    });

    basePost.eventStartDate = start.toIso8601String();
    basePost.eventEndDate = end.toIso8601String();

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: PostPath.create,
        data: basePost.toMap);

    setState(() {
      isLoading = false;
    });

    if (response["status"] == "success" && context.mounted) {
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Event Create Successful");
    } else {
      showDialog(
          context: context,
          builder: (context) => SystemMessage(
              content:
                  "Event Create Failed (Error: ${response["data"]["message"]})"));
    }
  }
}
