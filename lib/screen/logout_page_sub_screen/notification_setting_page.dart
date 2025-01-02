import 'package:flutter/material.dart';
import 'package:spark_up/notificatoin_manager.dart';
import 'package:spark_up/secure_storage.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Notification Setting",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF9F4F2),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 20,
            ),
            notificationSwitchWidget(
                "Allow Notification",
                NotificationManager.allowNotification,
                StoreKey.allowNotification),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              padding: const EdgeInsets.only(left: 10.0),
              child: const Text("Foreground Notification",
                  style: TextStyle(color: Color(0xFF827C79), fontSize: 12.0)),
            ),
            notificationSwitchWidget(
                "Chatroom message",
                NotificationManager.foregroundNewMessage,
                StoreKey.foregroundNewMessage),
            notificationSwitchWidget(
                "Approve message",
                NotificationManager.foregroundApproveMessage,
                StoreKey.foregroundApproveMessage),
            notificationSwitchWidget(
                "Reject message",
                NotificationManager.foregroundRejectMessage,
                StoreKey.foregroundRejectMessage),
            notificationSwitchWidget(
                "Apply message",
                NotificationManager.foregroundApplyMessage,
                StoreKey.foregroundApplyMessage),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 2.0),
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text("Background Notification",
                      style:
                          TextStyle(color: Color(0xFF827C79), fontSize: 12.0)),
                ),
                const Tooltip(
                  showDuration: Duration(seconds: 5),
                  exitDuration: Duration(milliseconds: 500),
                  triggerMode: TooltipTriggerMode.tap,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  message:
                      "Background notification only work while app is running in the background. Before use this feature, please check the device permission first.",
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: Color(0xFF827C79),
                    size: 18.0,
                  ),
                )
              ],
            ),
            notificationSwitchWidget(
                "Chatroom message",
                NotificationManager.backgroundNewMessage,
                StoreKey.backgroundNewMessage),
            notificationSwitchWidget(
                "Approve message",
                NotificationManager.backgroundApproveMessage,
                StoreKey.backgroundApproveMessage),
            notificationSwitchWidget(
                "Reject message",
                NotificationManager.backgroundRejectMessage,
                StoreKey.backgroundRejectMessage),
            notificationSwitchWidget(
                "Apply message",
                NotificationManager.backgroundApplyMessage,
                StoreKey.backgroundApplyMessage),
          ],
        ),
      ),
    );
  }

  Widget notificationSwitchWidget(
      String label, bool notificationOn, StoreKey key) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          Switch(
            value: notificationOn,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFF77D43),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFF827C79),
            onChanged: (value) {
              setState(() {
                notificationOn = value;
                NotificationManager.setNotification(key);
              });
            },
          ),
        ],
      ),
    );
  }
}
