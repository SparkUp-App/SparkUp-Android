import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class attributeTextfield extends StatefulWidget {
  const attributeTextfield({ //要求:key，標籤，提示文字，此文字框的icon，他所對應的值，回調函數，是否為必填(預設false)，要開幾格空間給他(預設1)
    super.key,
    required this.label,
    required this.attributeKey,
    required this.hintLabel,
    required this.textFieldIcon,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.maxLine = 1,
  });

  final String label;
  final String attributeKey;
  final String hintLabel;
  final String value;
  final String textFieldIcon;
  final Function(String?) onChanged; // 回條函數
  final bool isRequired;
  final int maxLine;
  @override
  State<attributeTextfield> createState() => _profile_TextfieldState();
}

class _profile_TextfieldState extends State<attributeTextfield> {
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
              widget.label + (widget.isRequired ? " *" : ""),//Require 要多顯示 * 號
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
                controller:  textController,
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
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      widget.textFieldIcon,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        Colors.black26,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  hintText: widget.hintLabel,
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                  ),
                ),
                onChanged: (value) {
                  widget.onChanged(value); // 将改变的值传递给父级
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}


