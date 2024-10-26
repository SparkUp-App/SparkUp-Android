import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:intl/intl.dart';

Step previewStep(BasePost basePost) {
  return Step(
    title: const SizedBox.shrink(),
    content: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.preview, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    "Preview",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              basePost.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Date and time
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue[700], size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${DateFormat('M/d HH:mm').format(basePost.eventStartDate)} - ${DateFormat('M/d HH:mm').format(basePost.eventEndDate)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // People required
                  Row(
                    children: [
                      Icon(Icons.group, color: Colors.green[700], size: 20),
                      SizedBox(width: 12),
                      Text(
                        "${basePost.numberOfPeopleRequired} people required",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red[700], size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          basePost.location,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Attributes section
            if (basePost.attributes.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                "Additional Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < basePost.attributes.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "${basePost.attributes.keys.elementAt(i)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "${basePost.attributes.values.elementAt(i)}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              )
            ],
          ],
        ),
      ),
    ),
  );
}