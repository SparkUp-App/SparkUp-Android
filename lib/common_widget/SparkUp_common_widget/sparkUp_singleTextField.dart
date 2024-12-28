import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Textfield extends StatefulWidget {
  const Textfield({
    super.key,
    required this.label,
    required this.hintLabel,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.maxLine = 1,
    this.onlyNumber = false, // 新增數字控制參數
    this.restrictWord, // 新增字數限制參數
  });

  final String label;
  final String hintLabel;
  final String value;
  final Function(String?) onChanged;
  final bool isRequired;
  final int maxLine;
  final bool onlyNumber; // 新增數字控制參數
  final int? restrictWord; // 新增字數限制參數

  @override
  State<Textfield> createState() => _profile_TextfieldState();
}

class _profile_TextfieldState extends State<Textfield> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.value);
    textController.addListener(_updateTextLength); // 監聽輸入改變
  }

  int _currentLength = 0; // 動態追蹤當前輸入長度

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _updateTextLength() {
    setState(() {
      _currentLength = textController.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標籤與字數統計顯示
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.label + (widget.isRequired ? " *" : ""),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE9765B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.restrictWord != null)
                  SizedBox(width: 5),
                if (widget.restrictWord != null)
                  Text(
                    '($_currentLength/${widget.restrictWord})',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                  ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextField(
                maxLines: widget.maxLine,
                controller: textController,
                // 根據 onlyNumber 添加數字鍵盤和輸入限制
                keyboardType: widget.onlyNumber
                    ? TextInputType.number
                    : TextInputType.text,
                // 添加數字輸入限制和字數限制
                inputFormatters: [
                  if (widget.onlyNumber) FilteringTextInputFormatter.digitsOnly,
                  if (widget.restrictWord != null)
                    LengthLimitingTextInputFormatter(widget.restrictWord),
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE9765B)),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintText: widget.hintLabel,
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                  ),
                ),
                onChanged: (value) {
                  widget.onChanged(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
