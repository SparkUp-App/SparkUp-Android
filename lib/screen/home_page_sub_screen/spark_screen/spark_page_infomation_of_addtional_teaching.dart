import 'package:flutter/material.dart';
import 'package:spark_up/route.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SparkPageInformationOfAdditionalTeaching extends StatelessWidget {
  final String category;

  const SparkPageInformationOfAdditionalTeaching({super.key, required this.category});

  // PDF檔案對應表
  final Map<String, List<String>> categoryPdfs = const {
    'Competition': ['assets/example_pdf/Competition_example1.pdf', 'assets/example_pdf/Competition_example2.pdf'], //ok
    'Exhibition': ['assets/example_pdf/Exhibition Example1.pdf', 'assets/example_pdf/Exhibition Example2.pdf'], //ok
    'Meal': ['assets/example_pdf/Meal Example1.pdf', 'assets/example_pdf/Meal Example2.pdf'], //ok
    'Parade': ['assets/example_pdf/Parade_example1.pdf', 'assets/example_pdf/Parade_example1.pdf'], //ok
    'Roommate': ['assets/example_pdf/Roommate_example1.pdf', 'assets/example_pdf/Roommate_example2.pdf'], //ok
    'Social': ['assets/example_pdf/Social Example1.pdf', 'assets/example_pdf/Social Example2.pdf'], //ok
    'Speech': ['assets/example_pdf/Competition_example1.pdf', 'assets/example_pdf/Competition_example1.pdf'],
    'Sport': ['assets/example_pdf/Sport_example1.pdf', 'assets/example_pdf/Sport_example2.pdf'], //ok
    'Study': ['assets/example_pdf/Study_example1.pdf', 'assets/example_pdf/Study_example2.pdf'], //ok
    'Travel': ['assets/example_pdf/Travel Example1.pdf', 'assets/example_pdf/Travel Example2.pdf'], //ok
  };

  Future<String> _preparePdfFile(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    final pdfs = categoryPdfs[category] ?? 
      ['assets/pdfs/default1.pdf', 'assets/pdfs/default2.pdf'];
Widget _buildSuccessCard(String category) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: Color(0xFFE9765B),
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Your post has been successfully posted under "$category".',
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF2D3142),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildBottomButton(BuildContext context) {
  return Container(
    height: 70,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, RouteMap.homePage),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE9765B),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Back to Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
    // 其餘UI代碼保持不變，直到ResourceCard部分

    return PopScope(
        canPop: false,
      child:Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Additional Teaching Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE9765B),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSuccessCard(category),
                    const SizedBox(height: 24),
                    _buildResourcesCard(context, category, pdfs),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
      ),
    );
  }

  Widget _buildResourcesCard(BuildContext context, String category, List<String> pdfs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Resources',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF2D3142),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ResourceCard(
            title: 'Template plan of $category 1',
            description: 'Access comprehensive tips',
            icon: Icons.school,
            pdfPath: pdfs[0],
            onTap: () async {
              final path = await _preparePdfFile(pdfs[0]);
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerPage(filePath: path,appbarname: "Template plan of $category 1"),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          ResourceCard(
            title: 'Template plan of $category 2',
            description: 'Access comprehensive tips',
            icon: Icons.school,
            pdfPath: pdfs[1],
            onTap: () async {
              final path = await _preparePdfFile(pdfs[1]);
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerPage(filePath: path,appbarname: "Template plan of $category 2"),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // 其他_build方法保持不變
}

class ResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String pdfPath;
  final VoidCallback onTap;

  const ResourceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.pdfPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFE9765B).withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9765B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFE9765B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2D3142),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF2D3142).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFFE9765B),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
 final String filePath;
 final String appbarname;
const PdfViewerPage({super.key, required this.filePath, required this.appbarname});

 @override 
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(
        appbarname,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
       ),
       backgroundColor: const Color(0xFFE9765B),
       centerTitle: true,
     ),
     body: SfPdfViewer.file(
       File(filePath),
       enableTextSelection: true,
       canShowScrollHead: true,
       enableDoubleTapZooming: true,
       pageLayoutMode: PdfPageLayoutMode.continuous,
       scrollDirection: PdfScrollDirection.vertical,
     ),
   );
 }
}
