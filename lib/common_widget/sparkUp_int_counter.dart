import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_svg/flutter_svg.dart';

class intCounterBox extends StatefulWidget {
  final String label;
  final bool isRequired;
  final double minValue;
  final double maxValue;
  final double initialValue;
  final Function(double) onChanged;

  const intCounterBox({
    super.key,
    required this.label,
    this.isRequired = false,
    this.minValue = 1,
    this.maxValue = 100,
    this.initialValue = 4,
    required this.onChanged,
  });

  @override
  State<intCounterBox> createState() => _intCounterBoxState();
}

class _intCounterBoxState extends State<intCounterBox> {
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
              width: MediaQuery.of(context).size.width * 0.75,
              child: Stack(
                children: [
                  SpinBox(
                    min: widget.minValue,
                    max: widget.maxValue,
                    value: widget.initialValue,
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 45),
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
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    spacing: 0,
                    incrementIcon: Icon(Icons.add, color: Colors.black26, size: 20),
                    decrementIcon: Icon(Icons.remove, color: Colors.black26, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}