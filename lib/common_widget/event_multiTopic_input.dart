import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopicMultiInput extends StatefulWidget {
  const TopicMultiInput({
    super.key,
    required this.topicsData,
    required this.onChanged,
  });

  final Map<String, List<String>> topicsData;
  final Function(Map<String, List<String>>) onChanged;

  @override
  State<TopicMultiInput> createState() => _TopicMultiInputState();
}

class _TopicMultiInputState extends State<TopicMultiInput> {
  late Map<String, List<TextEditingController>> topicControllers;
  late TextEditingController newTopicController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for existing topics and their values
    topicControllers = {};
    widget.topicsData.forEach((topic, values) {
      topicControllers[topic] = values
          .map((value) => TextEditingController(text: value))
          .toList();
    });
    newTopicController = TextEditingController();
  }

  void _addNewTopic() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new topic'),
          content: TextField(
            controller: newTopicController,
            decoration: InputDecoration(hintText: 'Topic Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                if (newTopicController.text.trim().isNotEmpty) {
                  setState(() {
                    topicControllers[newTopicController.text] = [];
                  });
                  newTopicController.clear();
                  Navigator.pop(context);
                  _updateValues();
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _removeTopic(String topic) {
    setState(() {
      topicControllers.remove(topic);
      _updateValues();
    });
  }

  void _addNewInput(String topic) {
    setState(() {
      topicControllers[topic]!.add(TextEditingController());
    });
  }

  void _removeInput(String topic, int index) {
    setState(() {
      topicControllers[topic]!.removeAt(index);
      _updateValues();
    });
  }

  void _updateValues() {
    Map<String, List<String>> newValues = {};
    topicControllers.forEach((topic, controllers) {
      newValues[topic] = controllers
          .map((controller) => controller.text.trim())
          .where((value) => value.isNotEmpty)
          .toList();
    });
    widget.onChanged(newValues);
  }

  Widget _buildInputTextField(String topic, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      width: MediaQuery.of(context).size.width * 0.75,
      child: Stack(
        children: [
          TextFormField(
            controller: topicControllers[topic]![index],
            decoration: InputDecoration(
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
              hintText: 'Enter describe',
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
              icon: Icon(Icons.delete),
              onPressed: () => _removeInput(topic, index),
              color: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicSection(String topic) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  topic,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFFE9765B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () => _removeTopic(topic),
                color: Color(0xFFE9765B),
              ),
            ],
          ),
          ...topicControllers[topic]!
              .asMap()
              .entries
              .map((e) => _buildInputTextField(topic, e.key)),
          SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: ElevatedButton(
              onPressed: () => _addNewInput(topic),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Color(0xFFE9765B)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              child: Text(
                'Add describe',
                style: TextStyle(color: Color(0xFFE9765B)),
              ),
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
        ...topicControllers.keys.map((topic) => _buildTopicSection(topic)),
        SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: ElevatedButton(
            onPressed: _addNewTopic,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE9765B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.0),
            ),
            child: Text(
              'Add new topic',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}