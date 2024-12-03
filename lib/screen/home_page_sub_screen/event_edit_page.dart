import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/confirm_dialog.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/data/post_view.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/post_path.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_singleTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_int_counter.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_datePicker.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_describe_container.dart';

class EventEditPage extends StatefulWidget {
  const EventEditPage({super.key, required this.postView});

  final PostView postView;

  @override
  State<EventEditPage> createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {
  late BasePost postData;
  bool processing = false;
  bool prePageReload = false;

  Map<String, dynamic> editData = {};
  Map<String, TextEditingController> textControllers = {};
  Map<String, dynamic> attributeData = {};

  @override
  void initState() {
    super.initState();
    postData = widget.postView.toBasePost();
    editData = Map<String, dynamic>.from(postData.toMap);
    attributeData = Map<String, dynamic>.from(editData["attributes"] ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7AF8B),
        title: const Text("Edit Event"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () async {
            if (changeJudge()) {
              final bool confirm = await confirmDialog(
                  context,
                  "Changes haven't been saved",
                  "Are you sure you want to leave edit page?");
              if (confirm) {
                Navigator.pop(this.context);
              }
            } else {
              Navigator.pop(this.context, (prePageReload, postData));
            }
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: _buildEditFields(),
                ),
              ),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

List<Widget> _buildEditFields() {
  List<Widget> fields = [
    const NoteCard(message: "Edit your event details here"),
  ];

  // Add non-attribute fields
  editData.forEach((key, value) {
      if (key== "event_start_date"||key== "event_end_date") {
        // Parse the initial date string to DateTime
        DateTime initialDate = DateTime.parse(value.toString()).toLocal();
        fields.add(_buildDatePicker(
          label: _formatLabel(key),
          date: initialDate,
          onDateChanged: (newDate) {
            setState(() {
              // Update the editData with the new date in ISO format
              editData[key] = newDate.toIso8601String();
            });
          },
        ));

        // Add time picker for start and end dates
        fields.add(_buildTimePicker(
          label: "${_formatLabel(key)} Time",
          time: TimeOfDay.fromDateTime(initialDate),
          onTimeChanged: (newTime) {
            setState(() {
              DateTime updatedDateTime = DateTime(
                initialDate.year,
                initialDate.month,
                initialDate.day,
                newTime.hour,
                newTime.minute,
              );
              editData[key] = updatedDateTime.toIso8601String();
            });
          },
          context: context,
        ));
      } else if(key=="title"){
        fields.add(Textfield(
            label: key,
            hintLabel: "Enter ${key} Here",
            value:  editData[key].toString(),
            onChanged: (newValue) => setState(() =>  editData[key] = newValue ?? ""),
            isRequired: true,
          )
        );
      }
      else if(key=="number_of_people_required"){
        fields.add(intCounterBox(
            label: "Number of people",
            isRequired: true,
            minValue: 1,
            maxValue: 100,
            initialValue: editData[key].toDouble(),
            onChanged: (newValue) {
              editData[key]  = newValue.toInt();
            },
          ),
        );
      }
  });

  // Add attribute fields
  (editData["attributes"] ?? {}).forEach((key, value) {
      print(key);
      print(value.runtimeType);
      //String , List<dynamic> , Map<String, dynamic>
      fields.add(
        Textfield(
            label: key,
            hintLabel: "Enter ${key} Here",
            value:  value.toString(),
            onChanged: (newValue) => setState(() =>  editData["attributes"][key] = newValue ?? ""),
          )
        );
      

  });

  return fields;
}

  String _formatLabel(String key) {
    // Implement your formatting logic here
    return key.replaceAll('_', ' ').toUpperCase();
  }

Widget _buildSaveButton() {
  return  processing
        ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Processing...",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
        : Container(
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.all(8),
    height: 55,
    width: MediaQuery.of(context).size.width * 0.6,
    decoration: BoxDecoration(
        color: const Color(0xFFF5A278),
        borderRadius: BorderRadius.circular(50)),
    child:TextButton(
            onPressed: () async {
              if (processing) return;
              if (editData['title'] == null || editData['title'].toString().trim().isEmpty) { //偵錯機制
                await showDialog(
                  context: context,
                  builder: (context) => const SystemMessage(
                    content: "Title cannot be empty",
                  ),
                );
                return;
              }

              //偵錯機制
              if (editData['event_start_date'] != null && editData['event_end_date'] != null) {
                DateTime startDate = DateTime.parse(editData['event_start_date']);
                DateTime endDate = DateTime.parse(editData['event_end_date']);

                if (startDate.isAfter(endDate)) {
                  await showDialog(
                    context: context,
                    builder: (context) => const SystemMessage(
                      content: "Start date cannot be later than end date",
                    ),
                  );
                  return;
                }
              }

              // 確認是否變更
              if (!changeJudge()) {
                await showDialog(
                    context: context,
                    builder: (context) => const SystemMessage(
                        content: "No change need to be saved"));
                return;
              }

              // 保存更改
              processing = true;
              setState(() {});

              BasePost updatePost = BasePost.initfromData(editData);

              final response = await Network.manager.sendRequest(
                  method: RequestMethod.post,
                  path: PostPath.update,
                  pathMid: ["${widget.postView.postId}"],
                  data: updatePost.toMap);

              if (context.mounted) {
                if (response["status"] == "success") {
                  await showDialog(
                      context: context,
                      builder: (context) => const SystemMessage(
                            content: "Save Change Success",
                          ));
                  bool prePageReload = true;
                  Navigator.pop(
                      this.context, (prePageReload, updatePost));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => const SystemMessage(
                            content:
                                "Save Change Failed\n Please Try Again Later",
                          ));
                }
              }

              processing = false;
              setState(() {});
            },
            child: const Text(
              "Save Changes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
  );
}

  bool changeJudge() {
    for (var element in editData.entries) {
      if (element.value != postData.toMap[element.key]) {
        return true;
      }
    }
    return false;
  }

Widget _buildDatePicker({
  required String label,
  required DateTime date,
  required Function(DateTime) onDateChanged,
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
              width: MediaQuery.of(context).size.width * 0.75,
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
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE9765B)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE9765B)),
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
  );
}

Widget _buildTimePicker({
  required String label,
  required TimeOfDay time,
  required Function(TimeOfDay) onTimeChanged,
  required BuildContext context,
}) {
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
              width: MediaQuery.of(context).size.width * 0.75,
              child: InkWell(
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );
                  if (selectedTime != null) {
                    controller.text = selectedTime.format(context);
                    onTimeChanged(selectedTime);
                  }
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE9765B)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE9765B)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE9765B)),
                        borderRadius: BorderRadius.circular(10.0),
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
}
