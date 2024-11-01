import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileDoubleTextFieldToMakeMap extends StatefulWidget {
  const ProfileDoubleTextFieldToMakeMap ({
    super.key,
    required this.label,
    required this.firstHintLabel,
    required this.secondHintLabel,
    required this.icon,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final String firstHintLabel;
  final String secondHintLabel;
  final String icon;
  final Map<String, String> values;
  final Function(Map<String, String>) onChanged;

  @override
  State<ProfileDoubleTextFieldToMakeMap > createState() => _ProfileDoubleTextFieldToMakeMapState();
}

class _ProfileDoubleTextFieldToMakeMapState extends State<ProfileDoubleTextFieldToMakeMap > {
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
  ) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: showIcon
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SvgPicture.asset(
                    widget.icon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      Colors.black26,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              : null,
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
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black26,
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
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          _buildInputTextField(
            controllerPairs[index].first,
            widget.firstHintLabel,
            true,
          ),
          SizedBox(width: 8),
          _buildInputTextField(
            controllerPairs[index].second,
            widget.secondHintLabel,
            false,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _removeInputPair(index),
            color: Colors.black26,
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
        for (int i = 0; i < controllerPairs.length; i++) _buildInputRow(i),
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _addNewInputPair,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE9765B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
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

// Helper class to store pairs of controllers
class Pair<T> {
  final T first;
  final T second;

  Pair(this.first, this.second);
}