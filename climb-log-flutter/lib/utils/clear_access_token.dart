import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> clearAccessToken() async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: 'accessToken');
}