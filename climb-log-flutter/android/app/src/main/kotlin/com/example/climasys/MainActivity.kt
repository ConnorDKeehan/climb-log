package com.connormdk.climasys

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Create notification channel for Android 8.0+ (API level 26+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "climasys_channel", // ID for the channel
                "New Climbs Notifications", // Name for the channel
                NotificationManager.IMPORTANCE_HIGH // Importance level
            ).apply {
                description = "Channel for new climb notifications to come through"
            }

            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }
}
