import 'package:flutter/material.dart';
import 'package:spark_up/route.dart';
import 'package:url_launcher/url_launcher.dart';

class SparkPageInformationOfAdditionalTeaching extends StatelessWidget {
  final String category;

  const SparkPageInformationOfAdditionalTeaching({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // 根据 category 动态设置 URL
    String teachingStrategiesUrl1 = '';
    String teachingStrategiesUrl2 = '';

    // 根据 category 设置不同的 URL
    if (category == 'Competition') {
      teachingStrategiesUrl1 = 'https://reurl.cc/mRlerj';
      teachingStrategiesUrl2 = 'https://reurl.cc/qnnKag'; // ok
    } else if (category == 'Exhibition') {
      teachingStrategiesUrl1 = 'https://reurl.cc/1XXkYV';
      teachingStrategiesUrl2 = 'https://reurl.cc/mRRk3V'; // ok
    } else if (category == 'Meal') {
      teachingStrategiesUrl1 = 'https://reurl.cc/044aZk';
      teachingStrategiesUrl2 = 'https://reurl.cc/Eggb1A'; // ok
    } else if (category == 'Parade') {
      teachingStrategiesUrl1 = 'https://reurl.cc/G55GED';
      teachingStrategiesUrl2 = 'https://reurl.cc/mRRk3V'; // ok
    } else if (category == 'Roommate') {
      teachingStrategiesUrl1 = 'https://reurl.cc/XZZaZE';
      teachingStrategiesUrl2 = 'https://reurl.cc/M66M6W'; // ok
    } else if (category == 'Social') {
      teachingStrategiesUrl1 = 'https://reurl.cc/mRRkMY';
      teachingStrategiesUrl2 = 'https://reurl.cc/1XXkv9'; // ok
    } else if (category == 'Speech') {
      teachingStrategiesUrl1 = 'https://reurl.cc/WAA8G5';
      teachingStrategiesUrl2 = 'https://reurl.cc/mRRk0G'; // ok
    } else if (category == 'Sport') {
      teachingStrategiesUrl1 = 'https://reurl.cc/eGGVyM';
      teachingStrategiesUrl2 = 'https://reurl.cc/866bXM';// ok
    }else if (category == 'Study') {
      teachingStrategiesUrl1 = 'https://reurl.cc/KddvVR';
      teachingStrategiesUrl2 = 'https://reurl.cc/lNNMEv';// ok
    } else if (category == 'Travel') {
      teachingStrategiesUrl1 = 'https://reurl.cc/qnnKr0';
      teachingStrategiesUrl2 = 'https://reurl.cc/d11qLk'; // ok 
    }  else {
      teachingStrategiesUrl1 = 'https://example.com/general-teaching-strategies';
      teachingStrategiesUrl2 = 'https://example.com/general-classroom-activities';
    }

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
              decoration: BoxDecoration(
                  color: Colors.white,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                          Row(
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
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
                            url: teachingStrategiesUrl1,  // Use dynamic URL
                            onTap: () {
                              print('Navigating to Teaching Strategies...');
                            },
                          ),
                          const SizedBox(height: 12),
                          ResourceCard(
                            title: 'Template plan of $category 2',
                            description: 'Access comprehensive tips',
                            icon: Icons.school,
                            url: teachingStrategiesUrl2,  // Use dynamic URL
                            onTap: () {
                              print('Navigating to Teaching Strategies...');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
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
          ),
        ],
      ),
    );
  }
}

// ResourceCard class remains unchanged
class ResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String url;  // Added a URL property
  final VoidCallback onTap;

  const ResourceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.url, // Pass URL to the constructor
    required this.onTap,
  });

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _launchURL(url);  // Use _launchURL method
          onTap();  // Optionally, you can keep the custom onTap behavior
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
