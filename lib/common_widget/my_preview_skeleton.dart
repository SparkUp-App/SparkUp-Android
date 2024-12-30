import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:math';

class PreviewSkeleton extends StatelessWidget {
  const PreviewSkeleton({Key? key}) : super(key: key);

  String _generateRandomSpaces(int length) {
    return ' ' * length; // 生成指定長度的空白字符
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final titleSpaces = _generateRandomSpaces(random.nextInt(50) + 40); // 隨機生成10到40個空白字符
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[100]!,
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
          const SizedBox(height: 10.0),
          // 標籤骨架
          Skeleton.leaf(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: const Color(0xFFff6b6b),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                titleSpaces, 
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          Skeleton.leaf(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: const Color(0xFFff6b6b),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                "                                                                                             ", 
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // 活動標題骨架
          Skeleton.leaf(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
              child:Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: const Color(0xFFff6b6b),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                "                                   ", // 使用隨機生成的空白字符
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  height: 1.5,
                ),
              ),
            ),
          ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class PreviewSkeletonList extends StatelessWidget {
  const PreviewSkeletonList({Key? key}) : super(key: key);

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
            return const PreviewSkeleton();
          },
        ),
      ),
    );
  }
}

class PreviewSkeletonListRandomLength extends StatelessWidget {
  const PreviewSkeletonListRandomLength({Key? key}) : super(key: key);

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
            return const PreviewSkeleton();
          },
        ),
      ),
    );
  }
}