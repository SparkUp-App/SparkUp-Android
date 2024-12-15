import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
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
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    debugPrint('Notification initialization started');

    try {
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
          // Handle notification tap
          selectNotificationSubject.add(notificationResponse.payload);
        },
      );
    } catch (e) {
      debugPrint('Notification initialization failed: $e');
    }
    await requestNotificationPermissions();
  }

  Future<bool> requestNotificationPermissions() async {
    bool permissionGranted = false;
    await Permission.location.request();

    try {
      if (Platform.isIOS) {
        // No dedicated in ios
      }

      if (Platform.isAndroid) {
        final result = await Permission.notification.request();
        permissionGranted = result.isGranted;
      }
    } catch (e) {
      debugPrint('Notification permission request failed: $e');
    }

    if (permissionGranted) {
      await createNotificationChannel();
    }

    return permissionGranted;
  }

  Future<void> createNotificationChannel() async {
    final androidPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    final Map<ChannelCategory, AndroidNotificationChannelConfig>
        cahnnelConifgs = {
      ChannelCategory.message: AndroidNotificationChannelConfig(
        importance: Importance.max,
        enableVibration: true,
        enableLigths: false,
        playSound: true,
        ledColor: const Color.fromARGB(255, 255, 0, 0),
      ),
      ChannelCategory.approved: AndroidNotificationChannelConfig(
        importance: Importance.max,
        enableVibration: true,
        enableLigths: false,
        playSound: true,
      ),
      ChannelCategory.rejected: AndroidNotificationChannelConfig(
        importance: Importance.max,
        enableVibration: true,
        enableLigths: false,
        playSound: true,
      ),
    };

    try {
      for (final category in ChannelCategory.values) {
        final config = cahnnelConifgs[category];
        await androidPlugin
            .createNotificationChannel(AndroidNotificationChannel(
          category.channelName,
          category.channelTitle,
          description: category.channelDescription,
          importance: Importance.max,
          enableVibration: config?.enableVibration ?? true,
          enableLights: config?.enableLigths ?? false,
          ledColor: config?.ledColor,
          playSound: config?.playSound ?? true,
        ));
      }
    } catch (e) {
      debugPrint('Notification channel creation failed: $e');
    }
  }

  Future<void> showNotification({
    required String body,
    required ChannelCategory category,
    String? payload,
  }) async {
    final int groudId = category.hashCode;

    // Android notification details
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      category.channelName,
      category.channelTitle,
      channelDescription: category.channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: category.channelName,
      setAsGroupSummary: false,
      groupAlertBehavior: GroupAlertBehavior.all,
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: category.channelTitle,
        summaryText: category.channelTitle,
        htmlFormatContent: true,
        htmlFormatTitle: true,
      ),
    );

    AndroidNotificationDetails summaryNotificationDetails =
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

    await flutterLocalNotificationsPlugin.show(
      groudId,
      category.channelTitle,
      "You have ${category.channelTitle}",
      NotificationDetails(
          android: summaryNotificationDetails,
          iOS: iOSPlatformChannelSpecifics),
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

class AndroidNotificationChannelConfig {
  final Importance importance;
  final bool enableVibration;
  final bool enableLigths;
  final Color? ledColor;
  final bool playSound;

  AndroidNotificationChannelConfig({
    this.importance = Importance.max,
    this.enableVibration = true,
    this.enableLigths = false,
    this.ledColor,
    this.playSound = true,
  });
}
