import 'package:flutter/material.dart';

class profileTagSelector extends StatefulWidget {
  const profileTagSelector({
    super.key,
    required this.label,
    required this.selectedTags,
    required this.availableTags,
    required this.onChanged,
    this.isRequired = false,
  });

  final String label;
  final List<String> selectedTags;
  final List<String> availableTags;
  final Function(List<String>) onChanged;
  final bool isRequired;

  @override
  State<profileTagSelector> createState() => _profileTagSelectorState();
}

class _profileTagSelectorState extends State<profileTagSelector> {
  late List<String> _selectedTags;
  late List<String> _availableTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
    _availableTags = List.from(widget.availableTags);
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
              widget.label + (widget.isRequired ? " *" : ""),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFE9765B),
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              width: MediaQuery.of(context).size.width * 0.80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _selectedTags
                        .map((tag) => Chip(
                              label: Text(
                                '#$tag',
                                style: const TextStyle(color: Colors.white),
                              ),
                              onDeleted: () {
                                setState(() {
                                  _selectedTags.remove(tag);
                                  _availableTags.add(tag);
                                  widget.onChanged(_selectedTags);
                                });
                              },
                              deleteIconColor: Colors.white,
                              backgroundColor: const Color(0xFFE9765B),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _showTagSelectionDialog(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE9765B)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Color(0xFFE9765B), size: 20),
                          SizedBox(width: 4),
                          Text(
                            'Add Tag',
                            style: TextStyle(
                              color: Color(0xFFE9765B),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showTagSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Choose your ${widget.label}',
                style: const TextStyle(color: Color(0xFFE9765B)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8.0,
                    children: _availableTags.map((String tag) {
                      return FilterChip(
                        label: Text(
                          "#$tag",
                          style: TextStyle(
                            color: _selectedTags.contains(tag) ? Colors.white : const Color(0xFFE9765B),
                          ),
                        ),
                        selected: _selectedTags.contains(tag),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags.add(tag);
                              _availableTags.remove(tag);
                            } else {
                              _selectedTags.remove(tag);
                              _availableTags.add(tag);
                            }
                          });
                        },
                        showCheckmark: false,
                        selectedColor: const Color(0xFFE9765B),
                        backgroundColor: Colors.grey[200],
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Color(0xFFE9765B)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {
        widget.onChanged(_selectedTags);
      });
    });
  }
}