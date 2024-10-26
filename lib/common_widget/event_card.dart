import 'package:flutter/material.dart';
import 'package:spark_up/data/list_receive_post.dart';

Widget eventCard(ListReceivePost receivedPost) {
  return Container(
    margin: const EdgeInsets.all(8.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: const Color(0xFFF7AF8B),
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 類型標籤
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            receivedPost.type,
            style: const TextStyle(
              color: Color(0xFFF7AF8B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        
        // 標題
        Text(
          receivedPost.title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),

        // 活動資訊
        // Text(
        //   "info: ${receivedPost.posterNickname}",
        //   style: const TextStyle(color: Colors.white70),
        // ),
        Text(
          "start date: ${receivedPost.eventStartDate.toString().split(' ')[0]}",
          style: const TextStyle(color: Colors.white70),
        ),
        Text(
          "end date: ${receivedPost.eventEndDate.toString().split(' ')[0]}",
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 16.0),

        // 喜愛與評論
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.favorite, color: Colors.white),
            const SizedBox(width: 4.0),
            Text(
              "${receivedPost.likes}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 16.0),
            const Icon(Icons.chat_bubble, color: Colors.white),
            const SizedBox(width: 4.0),
            Text(
              "${receivedPost.comments}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    ),
  );
}
