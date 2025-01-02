import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/spark_Icon.dart';
import 'package:spark_up/data/list_receive_post.dart';
import 'package:spark_up/route.dart';

Widget eventCard(ListReceivePost receivedPost, BuildContext context,
    Function refreshCallBack,
    {bool reviewStatusShow = false}) {
  return GestureDetector(
    onTap: () async {
      final edited = await Navigator.pushNamed(
        context,
        RouteMap.eventDetailePage,
        arguments: receivedPost.postId,
      );
      if (edited == true) refreshCallBack();
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA890).withOpacity(0.8),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 標籤
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  "#${receivedPost.type}",
                  style: const TextStyle(
                    color: Color(0xFFff6b6b),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              if (reviewStatusShow)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: switch (receivedPost.reviewStatus) {
                      0 => const Color(0XFFF77D43).withOpacity(0.7),
                      1 =>
                        const Color.fromARGB(255, 209, 57, 46).withOpacity(0.8),
                      2 => const Color(0xFF478BA2).withOpacity(0.8),
                      int() => Colors.grey.withOpacity(0.8),
                      null => Colors.grey.withOpacity(0.8),
                    },
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    switch (receivedPost.reviewStatus) {
                      0 => "Pending",
                      1 => "Rejected",
                      2 => "Approved",
                      int() => "Unknown Stage",
                      null => "Unknown Staeg",
                    },
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),

          // 活動標題
          Text(
            receivedPost.title,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const SparkIcon(
                          icon: SparkIcons.heart,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          "${receivedPost.likes}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15.0),
                    Row(
                      children: [
                        const SparkIcon(
                          icon: SparkIcons.comment,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          "${receivedPost.comments}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 15,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "${receivedPost.eventStartDate.toString().split(' ')[0].replaceAll("-", ".")} - ${receivedPost.eventEndDate.toString().split(' ')[0].replaceAll("-", ".")}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
