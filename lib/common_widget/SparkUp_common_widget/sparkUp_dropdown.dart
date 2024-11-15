import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dropdown extends StatefulWidget {
  const Dropdown({//要求:key，標籤，他所對應的值，此文字框的icon，選項(const xxxList)，回調函數，是否為必填
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.isRequired = false,
  });

  final String label;
  final String? value;
  final List<String> options;
  final Function(String?) onChanged;
  final bool isRequired;

  @override
  State<Dropdown> createState() => _ProfileDropdownState();
}

class _ProfileDropdownState extends State<Dropdown> {
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
              child: DropdownButtonFormField<String>(
                value: widget.value,
                isExpanded: true,
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                hint: const Text('Select Here', style: TextStyle(color: Colors.black26)),
                items: widget.options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(
                        color: option == 'Prefer not to say'
                            ? Colors.black38 // 如果選擇的是 'Prefer not to say'，顯示灰色
                            : Colors.black, // 其他選項顯示黑色
                      ),
                    ),
                  );
                }).toList(),
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