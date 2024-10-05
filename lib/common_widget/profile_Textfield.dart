import 'package:flutter/material.dart';

class profileTextfield extends StatefulWidget {
  const profileTextfield({
    super.key,
    required this.label,
    required this.hitLabel,
    required this.textFieldIcon,
    required this.value,
    required this.onChanged, 
  });

  final String label;
  final String hitLabel;
  final String value;
  final IconData textFieldIcon;
  final Function(String) onChanged; // 回调函数类型

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
              widget.label,
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
                  hintText: widget.hitLabel,
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


