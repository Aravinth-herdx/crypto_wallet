import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AppNotification {
  static const String _notificationChannelKey = 'crypto_app_notification';
  static const String _notificationChannelName = 'Crypto App Notification';

  static bool notificationInitialized = false;

  static void changeNotificationInitializedStatus() =>
      notificationInitialized = !notificationInitialized;

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/crypto',
      [
        NotificationChannel(
          channelKey: _notificationChannelKey,
          channelName: _notificationChannelName,
          channelDescription:
              'Notification channel for application notifications',
          defaultColor: Colors.grey,
          importance: NotificationImportance.Max,
          criticalAlerts: true,
          playSound: true,
        ),
      ],
    );
  }

  static void setupForegroundNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message.notification?.toMap());
      final data = message.data;
      final image = message.notification?.android?.imageUrl;
      if (message.notification != null) {
        final payload = <String, String?>{};
        for (final a in data.entries) {
          payload[a.key] = a.value as String?;
        }
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
            channelKey: _notificationChannelKey,
            title: message.notification?.title ?? '',
            body: message.notification?.body ?? '',
            backgroundColor: Colors.white,
            payload: payload,
            bigPicture: image,
            notificationLayout: image != null
                ? NotificationLayout.BigPicture
                : NotificationLayout.Default,
          ),
        );
      }
    });
  }
}
