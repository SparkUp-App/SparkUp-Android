import 'package:flutter/material.dart';
import 'package:spark_up/route.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SparkPageInformationOfAdditionalTeaching extends StatelessWidget {
  final String category;

  const SparkPageInformationOfAdditionalTeaching({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // 根據 category 動態設置 URL
    final Map<String, List<String>> categoryUrls = {
      'Competition': ['https://reurl.cc/mRlerj', 'https://reurl.cc/qnnKag'],
      'Exhibition': ['https://reurl.cc/1XXkYV', 'https://reurl.cc/mRRk3V'],
      'Meal': ['https://reurl.cc/044aZk', 'https://reurl.cc/Eggb1A'],
      'Parade': ['https://reurl.cc/G55GED', 'https://reurl.cc/mRRk3V'],
      'Roommate': ['https://reurl.cc/XZZaZE', 'https://reurl.cc/M66M6W'],
      'Social': ['https://reurl.cc/mRRkMY', 'https://reurl.cc/1XXkv9'],
      'Speech': ['https://reurl.cc/WAA8G5', 'https://reurl.cc/mRRk0G'],
      'Sport': ['https://reurl.cc/eGGVyM', 'https://reurl.cc/866bXM'],
      'Study': ['https://reurl.cc/KddvVR', 'https://reurl.cc/lNNMEv'],
      'Travel': ['https://reurl.cc/qnnKr0', 'https://reurl.cc/d11qLk'],
    };

    final urls = categoryUrls[category] ?? [
      'https://example.com/general-teaching-strategies',
      'https://example.com/general-classroom-activities'
    ];

    return Scaffold(
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
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSuccessCard(category),
                    const SizedBox(height: 24),
                    _buildResourcesCard(category, urls),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

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

  Widget _buildResourcesCard(String category, List<String> urls) {
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
            url: urls[0],
            onTap: () {
              debugPrint('Accessing template plan 1...');
            },
          ),
          const SizedBox(height: 12),
          ResourceCard(
            title: 'Template plan of $category 2',
            description: 'Access comprehensive tips',
            icon: Icons.school,
            url: urls[1],
            onTap: () {
              debugPrint('Accessing template plan 2...');
            },
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
}

class ResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String url;
  final VoidCallback onTap;

  const ResourceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.url,
    required this.onTap,
  });

  Future<void> _launchURL(BuildContext context) async {
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('無法開啟連結'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('錯誤: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _launchURL(context);
          onTap();
        },
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

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
        backgroundColor: const Color(0xFFE9765B),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE9765B),
              ),
            ),
        ],
      ),
    );
  }
}