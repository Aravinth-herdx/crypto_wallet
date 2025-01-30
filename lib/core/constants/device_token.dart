// import 'dart:convert';
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
//
// class DeviceTokenService {
//   final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
//
//   String? expoPushToken;
//
//   Future<String?> getDeviceToken() async {
//     try {
//       if (Platform.isAndroid) {
//         // Android-specific code to get a unique ID
//         final androidInfo = await _deviceInfoPlugin.androidInfo;
//         print('device');
//         print(androidInfo.id);
//         print(androidInfo.toMap());
//         return androidInfo.id;
//       } else if (Platform.isIOS) {
//         // iOS-specific code to get a unique ID
//         final iosInfo = await _deviceInfoPlugin.iosInfo;
//         return iosInfo.identifierForVendor; // Unique ID for iOS devices
//       }
//     } catch (e) {
//       print('Error getting device token: $e');
//     }
//     return null;
//   }
// }
