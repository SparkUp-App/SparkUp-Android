import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:math';

class EventCardSkeleton extends StatelessWidget {
  const EventCardSkeleton({Key? key}) : super(key: key);

  String _generateRandomSpaces(int length) {
    return ' ' * length; // 生成指定長度的空白字符
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final labelSpaces = _generateRandomSpaces(random.nextInt(15) + 10); // 隨機生成5到15個空白字符
    final titleSpaces = _generateRandomSpaces(random.nextInt(50) + 40); // 隨機生成10到40個空白字符

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.grey[300]!,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 標籤骨架
          Skeleton.leaf(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: const Color(0xFFff6b6b),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                labelSpaces, // 使用隨機生成的空白字符
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // 活動標題骨架
          Skeleton.leaf(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: const Color(0xFFff6b6b),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                titleSpaces, // 使用隨機生成的空白字符
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // 底部資訊骨架
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 左側互動數據
              Skeleton.leaf(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFff6b6b),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    "                    ", // 可以保持不變或隨機生成
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              // 右側日期
              Skeleton.leaf(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFff6b6b),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    "                                                         ", // 可以保持不變或隨機生成
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class eventCardSkeletonList extends StatelessWidget {
  const eventCardSkeletonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: Colors.black12,
        highlightColor: Colors.white24,
        duration: Duration(seconds: 1),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: 8,
          itemBuilder: (context, index) {
            return const EventCardSkeleton();
          },
        ),
      ),
    );
  }
}

class EventCardSkeletonListRandomLength extends StatelessWidget {
  const EventCardSkeletonListRandomLength({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomCount = random.nextInt(6) + 1;  // nextInt(6) 生成 0-5，加 1 變成 1-6

    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: Colors.black12,
        highlightColor: Colors.white24,
        duration: Duration(seconds: 1),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: randomCount,
          itemBuilder: (context, index) {
            return const EventCardSkeleton();
          },
        ),
      ),
    );
  }
}