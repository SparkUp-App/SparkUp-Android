import 'package:flutter/material.dart';

class profileDropdown extends StatefulWidget {
  const profileDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.dropdownIcon,
    required this.options,
    required this.onChanged,
    this.isRequired = false,
  });

  final String label;
  final String? value;
  final IconData dropdownIcon;
  final List<String> options;
  final Function(String?) onChanged;
  final bool isRequired;

  @override
  State<profileDropdown> createState() => _ProfileDropdownState();
}

class _ProfileDropdownState extends State<profileDropdown> {
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
              child: DropdownButtonFormField<String>(
                value: widget.value,
                isExpanded: true,
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  prefixIcon: Icon(widget.dropdownIcon),
                  prefixIconColor: Colors.black26,
                ),
                hint: const Text('Select Here', style: TextStyle(color: Colors.black26)),
                items: widget.options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
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