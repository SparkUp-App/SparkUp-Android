import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/spark_Icon.dart';
import 'package:spark_up/data/list_receive_post.dart';
import 'package:spark_up/route.dart';

Widget eventCard(ListReceivePost receivedPost, BuildContext context,
    Function refreshCallBack) {
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
        color: const Color(0xFFF7AF8B),
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
                      "${receivedPost.eventStartDate.toString().split(' ')[0]} - ${receivedPost.eventEndDate.toString().split(' ')[0]}",
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
