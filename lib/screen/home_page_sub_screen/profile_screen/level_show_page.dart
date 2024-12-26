import 'package:flutter/material.dart';

final List<Map<String, String>> spaceData = [
  {
    'image': 'assets/member/Nebulas.png',
    'name': 'Nebulas',
    'des': 'Participated in 0 - 10 events',
  },
  {
    'image': 'assets/member/Proto Star.png',
    'name': 'Protostar',
    'des': 'Participated in 11 - 20 events',
  },
  {
    'image': 'assets/member/Main Sequence.png',
    'name': 'Main Sequence',
    'des': 'Participated in 21 - 30 events',
  },
  {
    'image': 'assets/member/Red Giant.png',
    'name': 'Red Giant',
    'des': 'Participated in 31 - 40 events',
  },
  {
    'image': 'assets/member/Supernova.png',
    'name': 'Supernova',
    'des': 'Participated in over 40+ events',
  },
];

class levelShowPage extends StatelessWidget {
  const levelShowPage({super.key});

  // 定義顯示每個項目的 Widget
  Widget spaceMean(String spaceAssets, String spaceName, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F4F2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              spaceAssets, // 替換為圖片路徑
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spaceName, // 替換為項目名稱
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: "Kalam", // 確保已正確引入該字體
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description, // 動態展示描述文字
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Level Detail',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 158, 109),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 20),
        color: const Color(0xFFF9F4F2),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: spaceData.length, // 根據數據長度生成列表
                itemBuilder: (context, index) {
                  final item = spaceData[index]; // 獲取當前項目的數據
                  return spaceMean(
                    item['image']!, // 傳入圖片資源
                    item['name']!, // 傳入名稱
                    item['des'] ?? 'No description available', // 傳入描述
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
