import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:spark_up/chat/data/approved_message.dart';
import 'package:spark_up/chat/data/chat_message.dart';
import 'package:spark_up/chat/data/rejected_message.dart';

class BackgroundNotificationService {
  static final BackgroundNotificationService manager =
      BackgroundNotificationService();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> selectNotificationSubject =
      BehaviorSubject<String?>();

  Future<void> init() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // Handle notification tap
        selectNotificationSubject.add(notificationResponse.payload);
      },
    );
  }

  Future<void> showNotification({
    required String body,
    required ChannelCategory category,
    String? payload,
  }) async {
    // Android notification details
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(category.channelName, category.channelTitle,
            channelDescription: category.channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: category.channelName,
            setAsGroupSummary: true,
            groupAlertBehavior: GroupAlertBehavior.all);

    // iOS notification details
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    // Notification details
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      category.channelTitle,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // New Message Call Back Function
  void handleIncomingMessage(ChatMessage message) {
    showNotification(
        body: "${message.senderName}: ${message.content}",
        category: ChannelCategory.message);
  }

  void handleIncomingApprovedMessage(ApprovedMessage message) {
    showNotification(
        body:
            "${message.hostNickName} approved your apply in ${message.postTitle}",
        category: ChannelCategory.approved);
  }

  void handleIncomingRejectedMessage(RejectedMessage message) {
    showNotification(
        body:
            "${message.hostNickName} rejected your apply in ${message.postTitle}",
        category: ChannelCategory.rejected);
  }

  void dispose() {
    selectNotificationSubject.close();
  }
}

enum ChannelCategory {
  message,
  approved,
  rejected;

  String get channelName {
    switch (this) {
      case ChannelCategory.message:
        return 'new_message_channel';
      case ChannelCategory.approved:
        return 'approved_channel';
      case ChannelCategory.rejected:
        return 'rejected_channel';
    }
  }

  String get channelDescription {
    switch (this) {
      case ChannelCategory.message:
        return 'New Message Channel';
      case ChannelCategory.approved:
        return 'Approved Message Channel';
      case ChannelCategory.rejected:
        return 'Rejected Message Channel';
    }
  }

  String get channelTitle {
    switch (this) {
      case ChannelCategory.message:
        return 'New Message';
      case ChannelCategory.approved:
        return 'Approved Message';
      case ChannelCategory.rejected:
        return 'Rejected Message';
    }
  }
}