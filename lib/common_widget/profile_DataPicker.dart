import 'package:flutter/material.dart';

class profieldDatapicker extends StatefulWidget {
  const profieldDatapicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isRequired = true,
  });

  final String label;
  final String value;
  final Function(String) onChanged;
  final bool isRequired;

  @override
  State<profieldDatapicker> createState() => _ProfileDatePickerState();
}

class _ProfileDatePickerState extends State<profieldDatapicker> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(profieldDatapicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              child: InkWell(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2004),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
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
                      prefixIcon: const Icon(Icons.calendar_today),
                      prefixIconColor: Colors.black26,
                      hintText: "yyyy-MM-dd",
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