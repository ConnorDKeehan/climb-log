import 'package:climasys/climasys/features/login/login_page.dart';
import 'package:climasys/climasys/features/map_view/map_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'climasys/api/climasys_api.dart';
import 'utils/push_notification_service.dart'; // Import the LoginPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Fire and forget as we don't want this to pause initialization
  initializePushNotifications();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,              // keep it black (or any color)
      statusBarIconBrightness: Brightness.light, // white icons
    ),
  );

  runApp(const SafeArea(child: MyApp()));
}

void initializePushNotifications() async {
  await Firebase.initializeApp();
  // Initialize Push Notification Service
  PushNotificationService notificationService = PushNotificationService();
  await notificationService.initialize();
}

class MyApp extends StatelessWidget {
  // Create an instance of FlutterSecureStorage
  final storage = const FlutterSecureStorage();

  const MyApp({super.key});

  // Check if the user has a valid access token
  Future<bool> _checkAccessToken() async {
    try {
      String newToken = await refreshAccessToken();
      if (newToken.isNotEmpty) {
        // Update the stored token
        await storage.write(key: 'accessToken', value: newToken);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Token refresh failed
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boulder Bud',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
        dividerColor: Colors.transparent,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 2.0,
          shadowColor: Colors.grey
        )
      ),
      home: FutureBuilder<bool>(
        future: _checkAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while checking the token
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.data == true) {
              // Token is valid, proceed to MapView
              return const MapView();
            } else {
              // No valid token, show LoginPage
              return const LoginPage();
            }
          }
        },
      ),
    );
  }
}
