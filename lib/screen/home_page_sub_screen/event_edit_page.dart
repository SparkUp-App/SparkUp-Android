import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/confirm_dialog.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/data/post_view.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/post_path.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_singleTextField.dart';
import 'package:spark_up/common_widget/SparkUp_common_widget/sparkUp_multiTextField.dart';
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
    if (key != "attributes"&&key!="user_id"&&key!="type") {
      if (key== "event_start_date"||key== "event_end_date") {
        // Parse the initial date string to DateTime
        DateTime initialDate = DateTime.tryParse(value.toString()) ?? DateTime.now();
        fields.add(_buildDateTimePicker(
          _formatLabel(key),
          initialDate,
          (newDate) {
            setState(() {
              // Update the editData with the new date in ISO format
              editData[key] = newDate.toIso8601String();
            });
          },
        ));
      } else {
        fields.add(_createTextField(key, value.toString()));
      }
    }
  });

  // Add attribute fields
  (editData["attributes"] ?? {}).forEach((key, value) {
    if (key.toUpperCase() == "EVENT START DATE") {
      DateTime initialDate = DateTime.tryParse(value.toString()) ?? DateTime.now();
      fields.add(_buildDateTimePicker(
        _formatLabel(key),
        initialDate,
        (newDate) {
          setState(() {
            editData["attributes"][key] = newDate.toIso8601String();
          });
        },
      ));
    } else {
      fields.add(_createTextField(key, value.toString()));
    }
  });

  return fields;
}


  Widget _createTextField(String key, String initialValue) {
    return Textfield(
      label: _formatLabel(key),
      hintLabel: "Enter $key",
      value: initialValue,
      onChanged: (value) {
        setState(() {
          if (editData["attributes"] != null && editData["attributes"].containsKey(key)) {
            editData["attributes"][key] = value;
          } else {
            editData[key] = value;
          }
        });
      },
      maxLine: key.toLowerCase().contains('description') ? 3 : 1,
    );
  }

  String _formatLabel(String key) {
    // Implement your formatting logic here
    return key.replaceAll('_', ' ').toUpperCase();
  }

  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      height: 55,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
          color: const Color(0xFFF5A278),
          borderRadius: BorderRadius.circular(50)),
      child: processing
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : TextButton(
              onPressed: () async {
                if (processing) return;
                // Some Content Limit Judge

                // Have Change Judge
                if (!changeJudge()) {
                  showDialog(
                      context: context,
                      builder: (context) => const SystemMessage(
                          content: "No change need to be saved"));
                  return;
                }
                ;

                // Save Change
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

  Widget _buildDateTimePicker(String label, DateTime initialDate, Function(DateTime) onDateChanged) {
    return Datepicker(
      label: label,
      value: initialDate.toIso8601String().split('T')[0],
      onChanged: (value) {
        if (value != null) {
          onDateChanged(DateTime.parse(value));
        }
      },
    );
  }
}
