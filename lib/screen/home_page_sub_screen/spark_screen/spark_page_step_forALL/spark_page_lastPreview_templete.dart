import 'package:flutter/material.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:intl/intl.dart';

Step previewStep(BasePost basePost){
  return Step(
      title: const SizedBox.shrink(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start
        children: [
          Text("(Preview Screen)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16), // Added spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  basePost.title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8), // Spacing between title and time
          Text(
            "Time: ${DateFormat('yyyy-MM-dd HH:mm').format(basePost.eventStartDate)} - ${DateFormat('yyyy-MM-dd HH:mm').format(basePost.eventEndDate)}",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          SizedBox(height: 4), // Spacing between time and number of people
          Text(
            "Number of People Required: ${basePost.numberOfPeopleRequired}",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          SizedBox(height: 4), // Spacing between number of people and location
          Text(
            "Location: ${basePost.location}",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          SizedBox(height: 16), // Added spacing before attributes
          if (basePost.attributes.isNotEmpty)
            ...basePost.attributes.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        "${entry.key}: ${entry.value}",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
}
