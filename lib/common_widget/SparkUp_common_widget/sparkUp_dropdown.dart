import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.isRequired = false,
    this.icon, // 添加 icon 參數（如果需要）
  }) : super(key: key);

  final String label;
  final String? value;
  final List<String> options;
  final Function(String?) onChanged;
  final bool isRequired;
  final Widget? icon; // 添加 icon 參數

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75, // 使用 SizedBox 設置寬度
      child: Column(
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
          const SizedBox(height: 8.0),
          DropdownButtonFormField<String>(
            value: (widget.value != null && widget.value!.isNotEmpty) ? widget.value : null,
            isExpanded: true,
            decoration: InputDecoration(
              prefixIcon: widget.icon, // 使用 icon
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(20.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFE9765B)),
                borderRadius: BorderRadius.circular(20.0),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(20.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            hint: Text('Select ${widget.label}', style: const TextStyle(color: Colors.black26)),
            items: widget.options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: TextStyle(
                    color: option == 'Prefer not to say' ? Colors.black38 : Colors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}
