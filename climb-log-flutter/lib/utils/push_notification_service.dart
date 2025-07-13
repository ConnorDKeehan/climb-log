import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  }

  Future<void> initialize() async {
    // Request permissions for iOS
    _requestPermission();

    await getDeviceToken();
    await refreshAccessToken();

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String?> getDeviceToken() async {
    String? token;
    try{
      token = await _messaging.getToken();
    }
    catch(e){
      Exception("Cannot get Token");
    }

    return token;
  }
}
