import 'package:flutter/material.dart';

class SparkupSingleChoose extends StatefulWidget {
  const SparkupSingleChoose({
    super.key,
    required this.label,
    required this.hintlabel,
    required this.availableTags,
    required this.onChanged,
  });

  final String label;
  final String hintlabel;
  final List<String> availableTags;
  final Function(String) onChanged;

  @override
  State<SparkupSingleChoose> createState() => _SparkupSingleChooseState();
}

class _SparkupSingleChooseState extends State<SparkupSingleChoose> {
  String? _selectedTag;

  Future<void> _showOtherInputDialog() async {
    String? customOption;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Please enter other option'),
        content: TextField(
          onChanged: (value) {
            customOption = value;
          },
          decoration: InputDecoration(
            hintText: 'Other type',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (customOption?.isNotEmpty ?? false) {
                setState(() {
                  _selectedTag = customOption;
                  widget.onChanged(_selectedTag!);
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showTagSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please choose ${widget.label}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.availableTags.length + 1, (index) {
                if (index == widget.availableTags.length) {
                  return ListTile(
                    title: const Text(
                      'Other that is not on the list',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showOtherInputDialog();
                    },
                  );
                } else {
                  return ListTile(
                    title: Text(widget.availableTags[index]),
                    onTap: () {
                      setState(() {
                        _selectedTag = widget.availableTags[index];
                        widget.onChanged(_selectedTag!);
                      });
                      Navigator.pop(context);
                    },
                  );
                }
              }),
            ),
          ),
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
          InkWell(
            onTap: _showTagSelectionDialog,
            child: Container(
              padding: const EdgeInsets.all(12),
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTag ?? '${widget.label}',
                    style: TextStyle(
                      color: _selectedTag != null ? Colors.black : Colors.grey,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
