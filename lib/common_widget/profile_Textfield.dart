import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class profileTextfield extends StatefulWidget {
  const profileTextfield({
    super.key,
    required this.label,
    required this.hintLabel,
    required this.textFieldIcon,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.maxLine = 1,
  });

  final String label;
  final String hintLabel;
  final String value;
  final String textFieldIcon;
  final Function(String?) onChanged; // 回調函數
  final bool isRequired;
  final int maxLine;

  @override
  State<profileTextfield> createState() => _profile_TextfieldState();
}

class _profile_TextfieldState extends State<profileTextfield> {
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
              widget.label + (widget.isRequired ? " *" : ""), //Require 要多顯示 * 號
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
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0), // 為 prefixIcon 添加間距
                    child: SvgPicture.asset(
                      widget.textFieldIcon,
                      fit: BoxFit.contain,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40, // 確保圖標寬度
                    minHeight: 40, // 確保圖標高度
                  ),
                  hintText: widget.hintLabel,
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                  ),
                ),
                onChanged: (value) {
                  widget.onChanged(value); // 將變更的值傳遞給父級
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
