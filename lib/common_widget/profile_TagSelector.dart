import 'package:flutter/material.dart';

class ProfileTagSelect extends StatefulWidget {
  const ProfileTagSelect({
    Key? key,
    required this.label,
    required this.selectedTags,
    required this.availableTags,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final List<String> selectedTags;
  final List<String> availableTags;
  final Function(List<String>) onChanged;

  @override
  State<ProfileTagSelect> createState() => _ProfileTagSelectState();
}

class _ProfileTagSelectState extends State<ProfileTagSelect> {
  late List<String> _selectedTags;
  late List<String> _availableTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = List<String>.from(widget.selectedTags); //以免已經填過的資訊因為跳轉畫面導致錯誤
    _availableTags = List<String>.from(widget.availableTags);
  }

  void _showTagSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Choose your ${widget.label}'),
              scrollable: true,
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8.0,
                    children: _availableTags.map((String tag) {
                      return FilterChip(
                        label: Text("#$tag"),
                        selected: _selectedTags.contains(tag),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags.add(tag);
                              _availableTags.remove(tag);
                            } else {
                              _availableTags.add(tag);
                              _selectedTags.remove(tag);
                            }
                          });
                        },
                        showCheckmark: false,
                        selectedColor: Colors.blueAccent.withOpacity(0.3),
                        backgroundColor: Colors.grey[200],
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Confirm', style: TextStyle(
                    color: Color(0xFFF16743),
                  ),),
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onChanged(_selectedTags);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE9765B),
            ),
          ),
          const SizedBox(height: 8),
          Container( //不用textfield，直接用一個container顯示就好，爽
            height: 120, 
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack( //需要加一個加號按鈕，以第二層姿態疊上+號按鈕去
              children: [
                Visibility(
                  visible: _selectedTags.length == 0,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "At least choose a tag",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black26,
                      ),
                    ),
                  )
                ),
                ListView( //讓他可以滾動查看資訊，避免有人填了很長的資料，反而要犧牲版面問題
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap( //具彈性的Row
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _selectedTags.map((tag) {
                          return Chip(
                            label: Text('#$tag'),
                            onDeleted: () {
                              setState(() {
                                _selectedTags.remove(tag);
                                _availableTags.add(tag);
                                widget.onChanged(_selectedTags);
                              });
                            },
                            deleteIconColor: Colors.grey,
                            backgroundColor: Colors.grey[200],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Color(0xFFF16743)),
                    onPressed: _showTagSelectionDialog,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}