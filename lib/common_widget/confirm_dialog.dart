import 'package:flutter/material.dart';

Future<bool> confirmDialog(
    BuildContext context, String content, String? subContent) async {
  bool? result = await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
            content: content,
            subContent: subContent,
          ));
  return result ?? false;
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key, required this.content, this.subContent});
  final String content;
  final String? subContent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.antiAlias,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            content,
            style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          Text(subContent ?? ""),
        ],
      ),
      actionsPadding: const EdgeInsets.all(0),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black12),
                          right: BorderSide(width: 1, color: Colors.black12))),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ))),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1, color: Colors.black12))),
                margin: const EdgeInsets.all(0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
