import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'dart:math';

class EventCardSkeleton extends StatelessWidget {
  final Random _random = Random();
  
  double _getRandomWidth() {
    return _random.nextDouble() * (140 - 70) + 70;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 9.5),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF7AF8B).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container( //tag with random width
            width: _getRandomWidth(),
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          const SizedBox(height: 8.0),
          Container( //title
            width: double.infinity,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container( //like and comment
                width: 85,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              Container( //date
                width: 190,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget eventCardSkeletonList() {
  return SkeletonLoader(
    builder: EventCardSkeleton(),
    items: 8,
    period: const Duration(seconds: 1),
    highlightColor: Colors.black26,
    direction: SkeletonDirection.ltr,
  );
}