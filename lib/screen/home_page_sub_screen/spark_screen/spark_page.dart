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
  bool isLoading = false;
  int _index = 0; 
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
      body: Stepper(
      type: StepperType.horizontal,
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index < 2) {
          setState(() {
            _index += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          title: const Text('Step 1 title'),
          content: Column(
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
              margin: EdgeInsets.symmetric(vertical: marginVertical),
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
                        width: MediaQuery.of(context).size.width * 0.75,
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
            ],
          )
        ),
        Step(
          title: Text('Step 2 title'),
          content: Column(
            children: [
              Container(
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
                                basePost.eventStartDate = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    basePost.eventStartDate.hour,
                                    basePost.eventStartDate.minute);
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: TextField(
                              controller: TextEditingController(
                                  text: basePost.eventStartDate
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
                                basePost.eventStartDate = DateTime(
                                    basePost.eventStartDate.year,
                                    basePost.eventStartDate.month,
                                    basePost.eventStartDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute);
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: TextField(
                              controller: TextEditingController(
                                  text:
                                      "${basePost.eventStartDate.hour >= 12 ? "PM" : "AM"} ${basePost.eventStartDate.hour.toString().padLeft(2, "0")}:${basePost.eventStartDate.minute.toString().padLeft(2, "0")}"),
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
                              initialDate: basePost.eventStartDate,
                              firstDate: basePost.eventStartDate,
                              lastDate: DateTime(9999),
                            );

                            if (selectedDate != null) {
                              setState(() {
                                basePost.eventEndDate = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    basePost.eventEndDate.hour,
                                    basePost.eventEndDate.minute);
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: TextField(
                              controller: TextEditingController(
                                  text: basePost.eventEndDate
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
                                basePost.eventEndDate = DateTime(
                                    basePost.eventEndDate.year,
                                    basePost.eventEndDate.month,
                                    basePost.eventEndDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute);
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: TextField(
                              controller: TextEditingController(
                                  text:
                                      "${basePost.eventEndDate.hour >= 12 ? "PM" : "AM"} ${basePost.eventEndDate.hour.toString().padLeft(2, "0")}:${basePost.eventEndDate.minute.toString().padLeft(2, "0")}"),
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
            ],
          )
        ),
          if(basePost.type == 'sport')Step(
            title: const Text("Additional Info"),
            content: Column(
              children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: marginVertical,
                      horizontal: marginHorizontal,
                    ),
                    child: Text("SPORT"),
                  ),
              ],
            ),
          ),
      ],
      ),
    );/*SingleChildScrollView(
            
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
      return;
    } else if (basePost.eventStartDate.isAfter(basePost.eventEndDate)) {
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Event start time most before Event end time");
      return;
    }

    setState(() {
      isLoading = true;
    });

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
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (context) => SystemMessage(
              content:
                  "Event Create Failed (Error: ${response["data"]["message"]})"));
    }
  }
  */
  }
}
