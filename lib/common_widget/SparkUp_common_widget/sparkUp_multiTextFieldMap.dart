import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoubleTextFieldToMakeMap extends StatefulWidget {
  const DoubleTextFieldToMakeMap({
    super.key,
    required this.label,
    required this.firstHintLabel,
    required this.secondHintLabel,
    required this.values,
    required this.onChanged,
    this.onlyNumber = false, // 新增參數
  });

  final String label;
  final String firstHintLabel;
  final String secondHintLabel;
  final Map<String, String> values;
  final Function(Map<String, String>) onChanged;
  final bool onlyNumber; // 新增參數

  @override
  State<DoubleTextFieldToMakeMap> createState() => _ProfileDoubleTextFieldToMakeMapState();
}

class _ProfileDoubleTextFieldToMakeMapState extends State<DoubleTextFieldToMakeMap> {
  late List<Pair<TextEditingController>> controllerPairs;

  @override
  void initState() {
    super.initState();
    controllerPairs = [];
    widget.values.forEach((key, value) {
      controllerPairs.add(
        Pair(
          TextEditingController(text: key),
          TextEditingController(text: value),
        ),
      );
    });
    if (controllerPairs.isEmpty) {
      controllerPairs.add(
        Pair(
          TextEditingController(),
          TextEditingController(),
        ),
      );
    }
  }

  void _addNewInputPair() {
    setState(() {
      controllerPairs.add(
        Pair(
          TextEditingController(),
          TextEditingController(),
        ),
      );
    });
  }

  void _removeInputPair(int index) {
    setState(() {
      controllerPairs.removeAt(index);
      _updateValues();
    });
  }

  void _updateValues() {
    Map<String, String> newValues = {};
    for (var pair in controllerPairs) {
      String key = pair.first.text.trim();
      String value = pair.second.text.trim();
      if (key.isNotEmpty && value.isNotEmpty) {
        newValues[key] = value;
      }
    }
    widget.onChanged(newValues);
  }

  Widget _buildInputTextField(
    TextEditingController controller,
    String hintText,
    bool showIcon,
    Color backgroundcolor,
    Color hinttextcolor,
    Color textcolor,
    bool isSecondField, // 新增參數來識別是否為第二個輸入框
  ) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        // 根據 onlyNumber 和 isSecondField 設置數字鍵盤
        keyboardType: (widget.onlyNumber && isSecondField) 
            ? TextInputType.number 
            : TextInputType.text,
        // 根據 onlyNumber 和 isSecondField 設置輸入限制
        inputFormatters: (widget.onlyNumber && isSecondField) 
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        style: TextStyle(
          fontSize: 14,
          color: textcolor
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: backgroundcolor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), 
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE9765B)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: hinttextcolor,
            fontSize: 14, 
          ),
        ),
        onChanged: (value) {
          _updateValues();
        },
      ),
    );
  }

  Widget _buildInputRow(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          _buildInputTextField(
            controllerPairs[index].first,
            widget.firstHintLabel,
            true,
            const Color(0xFFE9765B),
            Colors.white.withOpacity(0.8),
            Colors.white,
            false, // 第一個輸入框
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              ":",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE9765B),
              ),
            ),
          ),
          _buildInputTextField(
            controllerPairs[index].second,
            widget.secondHintLabel,
            false,
            Colors.white,
            Colors.black26,
            Colors.black,
            true, // 第二個輸入框
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20), 
            onPressed: () => _removeInputPair(index),
            color: Colors.black26,
            padding: const EdgeInsets.all(4), 
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.75;
    
    return Container(
      width: containerWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14, 
              color: Color(0xFFE9765B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4), 
          for (int i = 0; i < controllerPairs.length; i++) _buildInputRow(i),
          const SizedBox(height: 4), 
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addNewInputPair,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE9765B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), 
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20, 
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var pair in controllerPairs) {
      pair.first.dispose();
      pair.second.dispose();
    }
    super.dispose();
  }
}

class Pair<T> {
  final T first;
  final T second;

  Pair(this.first, this.second);
}