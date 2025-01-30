// import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String? expoPushToken;

  Future<void> initializeFCM() async {
    final prefs = await SharedPreferences.getInstance();
    // if (prefs.getString('fcmToken') == null) {
    String? token = await _firebaseMessaging.getToken();
    print('Fcm Toke:');
    print(token);
    if (token != null) {
      await prefs.setString('fcmToken', token);
      // await sendTokenToBackend(token);
      // }
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      // await sendTokenToBackend(newToken);
    });
  }

// Future<void> sendTokenToBackend(String fcmToken) async {
//   final prefs = await SharedPreferences.getInstance();
//   final int? userId = await SharedPrefHelper.getUserId();
//   final String token = await SharedPrefHelper.getToken() ?? '';
//   try {
//     final response = await http.post(
//       Uri.parse(Api.fcmToken),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token'
//       },
//       body: jsonEncode({'userId': userId, 'fcmtoken': fcmToken}),
//     );
//     if (response.statusCode == 200) {
//       await prefs.setString('fcmToken', fcmToken);
//     } else {
//       throw Exception('Failed to send token to backend');
//     }
//   } catch (e) {
//     print("Error sending token: $e");
//   }
// }

  // Future<String?> generateExpoPushToken() async {
  //   try {
  //     final deviceInfo = DeviceInfoPlugin();
  //     final prefs = await SharedPreferences.getInstance();
  //     String? deviceId;
  //
  //     String platform = Platform.isIOS ? 'ios' : 'android';
  //
  //     Map<String, dynamic> deviceData;
  //
  //     if (Platform.isIOS) {
  //       final iosInfo = await deviceInfo.iosInfo;
  //       deviceData = {
  //         'deviceId': deviceId,
  //         'platform': platform,
  //         'model': iosInfo.model,
  //         'systemVersion': iosInfo.systemVersion,
  //         'localizedModel': iosInfo.localizedModel,
  //       };
  //     } else {
  //       final androidInfo = await deviceInfo.androidInfo;
  //       deviceData = {
  //         'deviceId': androidInfo.id,
  //         'platform': platform,
  //         'model': androidInfo.model,
  //         'manufacturer': androidInfo.manufacturer,
  //         'version': androidInfo.version.release,
  //       };
  //     }
  //
  //     String tokenData = json.encode(deviceData);
  //     String token = base64Url.encode(utf8.encode(tokenData));
  //
  //     expoPushToken = 'ExponentPushToken[$token]';
  //     print('Generated Expo Push Token: $expoPushToken');
  //     await prefs.setString('expoToken', token);
  //     return expoPushToken;
  //   } catch (e) {
  //     print('Error generating Expo push token: $e');
  //     return null;
  //   }
  // }

  // Future<String?> generateExpoPushToken(BuildContext context) async {
  //   try {
  //     // Get device info
  //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //     String deviceId = '';
  //
  //     if (Theme.of(context).platform == TargetPlatform.android) {
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //       deviceId = androidInfo.id;
  //     } else if (Theme.of(context).platform == TargetPlatform.iOS) {
  //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //       deviceId = iosInfo.identifierForVendor!;
  //     }
  //
  //     // Generate a unique identifier
  //     final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //     final input = '$deviceId-$timestamp';
  //
  //     // Create SHA-256 hash
  //     final bytes = utf8.encode(input);
  //     final hash = sha256.convert(bytes);
  //
  //     // Format the token
  //     print('ExponentPushToken[${hash.toString()}]');
  //     return 'ExponentPushToken[${hash.toString().substring(0, 20)}]';
  //   } catch (e) {
  //     print('Error generating Expo push token: $e');
  //     return null;
  //   }
  // }

  static const MethodChannel _platform = MethodChannel('com.example.device_token');

  static Future<String?> getDeviceToken() async {
    try {
      final String? token = await _platform.invokeMethod<String>('getDeviceToken');
      print('Device Token from Native: $token');
      return token;
    } catch (e) {
      print('Failed to get device token: $e');
      return null;
    }
  }
}

class DeviceTokenService {


// // Fetch device token using OneSignal
// static Future<String?> getDeviceTokenFromOneSignal() async {
//   try {
//     final deviceState = await OneSignal.shared.getDeviceState();
//     final String? deviceToken = deviceState?.userId; // OneSignal user ID
//     print('Device Token from OneSignal: $deviceToken');
//     return deviceToken;
//   } catch (e) {
//     print('Failed to get device token from OneSignal: $e');
//     return null;
//   }
// }
}
