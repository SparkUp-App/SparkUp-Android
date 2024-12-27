import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class profieldDatepicker extends StatefulWidget {
  const profieldDatepicker({//要求:key，標籤，他所對應的值，此文字框的icon，回調函數，是否為必填
    super.key,
    required this.label,
    required this.value,
    required this.datepickerIcon,
    required this.onChanged,
    this.isRequired = false,
    this.initDate,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final String value;
  final String datepickerIcon;
  final Function(String?) onChanged;
  final bool isRequired;
  final DateTime? initDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<profieldDatepicker> createState() => _ProfileDatePickerState();
}

class _ProfileDatePickerState extends State<profieldDatepicker> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
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
              child: InkWell(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.initDate ?? DateTime.now(),
                    firstDate: widget.firstDate ?? DateTime(1900),
                    lastDate: widget.lastDate ?? DateTime.now(),
                  );

                  if (selectedDate != null) {
                    String formattedDate = selectedDate.toIso8601String().split('T')[0];
                    widget.onChanged(formattedDate);
                    _controller.text = formattedDate;
                  }
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: _controller,
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
                    padding: EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      widget.datepickerIcon,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        Colors.black26,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                      prefixIconColor: Colors.black26,
                      hintText: "yyyy-mm-dd",
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}