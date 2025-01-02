import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/spark_Icon.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Us",
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
      backgroundColor: const Color(0xFFF9F4F2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/sparkupIcon.png',
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SparkIcon(
                  icon: SparkIcons.message,
                  size: 14.0,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                GestureDetector(
                    onTap: _launchEmail,
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Gmail: sparkup4111850@gmail.com",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'sparkup4111850@gmail.com',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint('Cannot launch email');
    }
  }
}
