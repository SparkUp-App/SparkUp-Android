import 'package:flutter/material.dart';

class profileTextfield extends StatefulWidget {
  const profileTextfield({ //要求:key，標籤，提示文字，此文字框的icon，他所對應的值，回調函數，是否為必填(預設false)，要開幾格空間給他(預設1)
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
  final IconData textFieldIcon;
  final Function(String?) onChanged; // 回條函數
  final bool isRequired;
  final int maxLine;
  @override
  State<profileTextfield> createState() => _profile_TextfieldState();
}

class _profile_TextfieldState extends State<profileTextfield> {
  var textController = TextEditingController();

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
              width: MediaQuery.of(context).size.width * 0.80,
              child: TextField(
                maxLines: widget.maxLine,
                controller:  textController,
                decoration: InputDecoration(
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
                  prefixIcon: Icon(widget.textFieldIcon),
                  prefixIconColor: Colors.black26,
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


