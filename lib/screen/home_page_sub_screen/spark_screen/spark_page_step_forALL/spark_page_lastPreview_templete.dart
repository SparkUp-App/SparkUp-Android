import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/common_widget/preview_detail_data.dart';
Step previewStep(BasePost basePost) {
  return Step(
    title: const SizedBox.shrink(),
    content: InfoPreviewCard(
      title: basePost.title,
      startDate: basePost.eventStartDate,
      endDate: basePost.eventEndDate,
      peopleRequired: basePost.numberOfPeopleRequired,
      location: basePost.location,
      attributes: basePost.attributes,
      content: basePost.content,
      showPreviewBadge: true,
    ),
  );
}
