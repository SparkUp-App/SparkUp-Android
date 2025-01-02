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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error,),
          const SizedBox(width: 8),
          const Text(
            'Warning',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            content,
            style: const TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
          Text(subContent ?? "", style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold,color: Colors.black54),),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            foregroundColor: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context, true);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}