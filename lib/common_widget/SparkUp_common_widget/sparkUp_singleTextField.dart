import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  });

  final String label;
  final String hintLabel;
  final String value;
  final Function(String?) onChanged;
  final bool isRequired;
  final int maxLine;
  final bool onlyNumber; // 新增數字控制參數

  @override
  State<Textfield> createState() => _profile_TextfieldState();
}

class _profile_TextfieldState extends State<Textfield> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label + (widget.isRequired ? " *" : ""),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFE9765B),
                fontWeight: FontWeight.w600,
              ),
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
                // 如果 onlyNumber 為 true，則添加數字輸入限制
                inputFormatters: widget.onlyNumber 
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE9765B)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10.0),
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