import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              'assets/No_Event_space.png', // 替換為你的 PNG 圖片路徑
              width: MediaQuery.of(context).size.width * 0.9, // 寬度設置為屏幕的 90%
              height: MediaQuery.of(context).size.height * 0.35,
              fit: BoxFit.contain, // 確保圖片不會變形
            ),
            const SizedBox(height: 16), // 圖片與文字之間的間距
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center, // 確保文字居中
                maxLines: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
