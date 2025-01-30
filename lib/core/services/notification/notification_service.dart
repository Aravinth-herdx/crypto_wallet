// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _notifications =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> initialize() async {
//     const initializationSettings = InitializationSettings(
//       iOS: DarwinInitializationSettings(),
//     );
//     await _notifications.initialize(initializationSettings);
//   }
//
//   Future<void> showTransactionNotification(
//       String title,
//       String body,
//       ) async {
//     const notificationDetails = NotificationDetails(
//       iOS: DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       ),
//     );
//
//     await _notifications.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//     );
//   }
// }