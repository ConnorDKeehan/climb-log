import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:climasys/climasys/features/select_gym/select_gym.dart';

// Flutter Secure Storage instance
const storage = FlutterSecureStorage();

// Fixed Function
Future<String> getGymName(BuildContext context) async {
  String? gymName = await storage.read(key: 'gymName');
  if (gymName == null) {
    // Navigate to the select gym page
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectGym()),
    );
  }

  return gymName ?? "";
}

Future<String?> getAccessToken() async {
  String? accessToken = await storage.read(key: 'accessToken');

  return accessToken;
}

const configApiBaseUrl = 'https://climblog.connormdk.xyz';
const configApiSuccessResponses = [200, 201, 204];

