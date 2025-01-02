import 'package:flutter/material.dart';

class MultiInput extends StatefulWidget {
  const MultiInput({
    super.key,
    required this.label,
    required this.hintLabel,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final String hintLabel;
  final List<String> values;
  final Function(List<String>) onChanged;

  @override
  State<MultiInput> createState() => _ProfileMultiInputState();
}

class _ProfileMultiInputState extends State<MultiInput> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = widget.values.map((value) => TextEditingController(text: value)).toList();
  }

  void _addNewInput() {
    // 檢查是否有未填寫的 TextField
    bool hasEmptyField = controllers.any((controller) => controller.text.trim().isEmpty);
    if (hasEmptyField) {
      // 提示使用者填寫內容
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all input fields before adding!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 如果所有框都已填寫，新增一個新的輸入框
    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void _removeInput(int index) {
    setState(() {
      controllers.removeAt(index);
      _updateValues();
    });
  }

  void _updateValues() {
    List<String> newValues = controllers
        .map((controller) => controller.text.trim())
        .where((value) => value.isNotEmpty)
        .toList();
    widget.onChanged(newValues);
  }

  Widget _buildInputTextField(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      width: MediaQuery.of(context).size.width * 0.75,
      child: Stack(
        children: [
          TextFormField(
            controller: controllers[index],
            decoration: InputDecoration(
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
              hintText: widget.hintLabel,
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
            ),
            onChanged: (value) {
              _updateValues();
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeInput(index),
              color: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        for (int i = 0; i < controllers.length; i++) _buildInputTextField(i),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          height: 1,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: ElevatedButton(
            onPressed: _addNewInput,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE9765B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
