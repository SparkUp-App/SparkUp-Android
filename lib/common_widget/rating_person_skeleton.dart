import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:math';

class RateingSkeleton extends StatelessWidget {
  const RateingSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeleton.leaf(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(16),
            bottom: const Radius.circular(16), // 依樣保持圓角
          ),
          color: const Color(0xFFF5A278), // 使用參考容器的背景色
          
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // 與參考的內間距一致
          child: SizedBox(
            height: 260,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.assignment,
                        color: Colors.white,
                        size: 24, // 使用相同的圖標大小
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 16, // 模擬文字高度
                          color: Colors.white.withOpacity(0.5), // 使用骨架效果
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 28, // 模擬圖標大小
                  width: 28,
                  color: Colors.white.withOpacity(0.5), // 模擬箭頭骨架效果
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class RateingSkeletonListRandomLength extends StatelessWidget {
  const RateingSkeletonListRandomLength({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomCount = random.nextInt(6) + 3; // nextInt(6) 生成 0-5，加 1 變成 1-6

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
            return const RateingSkeleton();
          },
        ),
      ),
    );
  }
}
