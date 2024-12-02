import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/confirm_dialog.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/data/post_view.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/post_path.dart';

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

  @override
  void initState() {
    super.initState();
    postData = widget.postView.toBasePost();
    editData = postData.toMap;
    for (var element in postData.toMap.keys) {
      if (element == "attributes") {
        for (var element in postData.toMap["attributes"].keys) {
          textControllers[element] = TextEditingController(
              text: editData["attributes"][element].toString());
        }
      } else {
        textControllers[element] =
            TextEditingController(text: editData[element].toString());
      }
    }
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
              child: Column(
                children: [
                  // Event Content

                  for (var element in editData.entries) ...[
                    if (element.key != "attributes") ...[
                      Container(
                          margin: const EdgeInsets.all(8),
                          child: editorWidget(
                              element.key, textControllers[element.key]!))
                    ],
                    if (element.key == "attributes") ...[
                      for (var element in editData["attributes"].entries) ...[
                        Container(
                            margin: const EdgeInsets.all(8),
                            child: editorWidget(
                                element.key, textControllers[element.key]!))
                      ]
                    ]
                  ],
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
            height: 0.0,
          ),
          Container(
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
          )
        ],
      ),
    );
  }

  Widget editorWidget(String tag, TextEditingController contorller) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            tag,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextField(
              controller: contorller,
              onChanged: (value) {
                editData[tag] = value;
              },
            ),
          )
        ],
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
}
