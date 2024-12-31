import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';

class ProfileMultiInput extends StatefulWidget {
  const ProfileMultiInput({
    super.key,
    required this.label,
    required this.hintLabel,
    required this.icon,
    required this.values,
    required this.onChanged,
    this.limit = 10,
  });

  final String label;
  final String hintLabel;
  final String icon;
  final List<String> values;
  final int limit;
  final Function(List<String>) onChanged;

  @override
  State<ProfileMultiInput> createState() => _ProfileMultiInputState();
}

class _ProfileMultiInputState extends State<ProfileMultiInput> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = widget.values
        .map((value) => TextEditingController(text: value))
        .toList();
    ToastService.showToastNumber(1);
  }

  void _addNewInput() {
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
                prefixIcon: Padding(
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
                ),
                prefixIconColor: Colors.black26,
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
                hintText: widget.hintLabel,
                hintStyle: const TextStyle(
                  color: Colors.black26,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _removeInput(index);
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.black26,
                  iconSize: 20.0,
                )),
            onChanged: (value) {
              _updateValues();
            },
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
            onPressed: () {
              for (var item in controllers) {
                if (item.text.isEmpty) {
                  ToastService.showErrorToast(
                    context,
                    message:
                        "Please fill all the fields before adding new field",
                    length: ToastLength.medium,
                    expandedHeight: 100,
                  );
                  return;
                }
              }

              if(controllers.length == widget.limit){
                ToastService.showErrorToast(
                  context,
                  message: "You can't add more than ${widget.limit} fields",
                  length: ToastLength.medium,
                  expandedHeight: 100,
                );
                return;
              }

              _addNewInput();
            },
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
}
