import 'package:flutter/material.dart';
import 'package:spark_up/route.dart';
import 'package:spark_up/secure_storage.dart';
import 'package:spark_up/socket_service.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  void logoutProcess(BuildContext context) {
    SecureStorage.delete(StoreKey.userId);
    SecureStorage.delete(StoreKey.noProfile);
    SocketService.manager.disconnect();
    Navigator.of(context).pushReplacementNamed(RouteMap.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7AF8B),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Return to the previous page
          },
        ),
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 50.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.notifications, color: Colors.grey),
                label: const Text("Notification",
                    style: TextStyle(color: Colors.black)),
                style: TextButton.styleFrom(
                  overlayColor: const Color(0xFFF7AF8B),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  backgroundColor: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              height: 50.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.card_travel, color: Colors.grey),
                label: const Text("License",
                    style: TextStyle(color: Colors.black)),
                style: TextButton.styleFrom(
                  overlayColor: const Color(0xFFF7AF8B),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  backgroundColor: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Container(
              height: 50.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone, color: Colors.grey),
                label: const Text("Contact us",
                    style: TextStyle(color: Colors.black)),
                style: TextButton.styleFrom(
                  overlayColor: const Color(0xFFF7AF8B),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  backgroundColor: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Container(
              height: 50.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.info, color: Colors.grey),
                label: const Text("About us",
                    style: TextStyle(color: Colors.black)),
                style: TextButton.styleFrom(
                  overlayColor: const Color(0xFFF7AF8B),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  backgroundColor: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              height: 50.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: TextButton.icon(
                onPressed: () {
                  logoutProcess(context);
                },
                icon: const Icon(Icons.logout, color: Colors.grey),
                label:
                    const Text("Logout", style: TextStyle(color: Colors.black)),
                style: TextButton.styleFrom(
                  overlayColor: const Color(0xFFF7AF8B),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  backgroundColor: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
