import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/spark_Icon.dart';
import 'package:spark_up/data/list_receive_post.dart';
import 'package:spark_up/route.dart';

Widget eventCard(ListReceivePost receivedPost, BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pushNamed(
      context,
      RouteMap.eventDetailePage,
      arguments: receivedPost.postId,
    ),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration( //漸層色
        gradient: LinearGradient(
          colors: [Color(0xFFff9a8b), Color(0xFFF7AF8B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 標籤
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              "#${receivedPost.type}",
              style: TextStyle(
                color: Color(0xFFff6b6b),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // 活動標題
          Text(
            receivedPost.title,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10.0),

          // 加強顯示日期
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.black12.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "Start: ${receivedPost.eventStartDate.toString().split(' ')[0]}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "End: ${receivedPost.eventEndDate.toString().split(' ')[0]}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          
          Padding(
            padding: EdgeInsets.all(3.0),
            child: Row(
            children: [
              Row(
                children: [
                  const SparkIcon(
                    icon: SparkIcons.heart,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    "${receivedPost.likes}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20.0),
              Row(
                children: [
                  const SparkIcon(
                    icon: SparkIcons.comment,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    "${receivedPost.comments}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          )
        ],
      ),
    ),
  );
}
