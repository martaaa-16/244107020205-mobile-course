# AI Challenge - Output Awal AI

Berikut adalah draf kode awal yang dihasilkan oleh AI coding assistant berdasarkan prompt yang diberikan:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

// ⚠️ TOP-LEVEL FUNCTION (Wajib di luar class & anotasi entry-point agar bisa dijalankan di isolate terpisah)
// ❌ DILARANG Mengakses BuildContext di sini!
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Background message received: ${message.messageId}");
}

class PushService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  // 1. Request Permission & Token Management
  Future<void> initPushService({
    required void Function(String route) onNavigate,
  }) async {
    // ⚠️ PERBEDAPAN PLATFORM:
    // Android 13+ (API 33+) membutuhkan izin POST_NOTIFICATIONS dari user.
    // iOS membutuhkan izin alert, badge, & sound via requestPermission.
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Ambil Token FCM
      String? token = await _fcm.getToken();
      if (token != null) {
        await _sendTokenToBackend(token);
      }

      // Listener Refreshed Token
      _fcm.onTokenRefresh.listen((newToken) async {
        await _sendTokenToBackend(newToken);
      });
    }

    // Inisialisasi Local Notifications untuk Foreground Banner
    await _initLocalNotifications(onNavigate);

    // Setup Event Listeners
    _setupMessageHandlers(onNavigate);

    // Default Topic Subscription
    await subscribeToTopic('pengumuman-kampus');
  }

  // Kirim token ke Backend (POST /devices)
  Future<void> _sendTokenToBackend(String token) async {
    try {
      final savedToken = await _storage.read(key: 'jwt_token');
      // ⚠️ KEAMANAN: Jangan mencetak token penuh di log produksi!
      debugPrint("Sending FCM token to backend: ${token.substring(0, 12)}...");

      await _dio.post(
        'https://api.campus.ac.id/devices',
        data: {'fcm_token': token},
        options: Options(headers: {'Authorization': 'Bearer $savedToken'}),
      );
    } catch (e) {
      debugPrint("Failed to send token to backend: $e");
    }
  }

  // Inisialisasi Local Notification Plugin (Untuk Foreground State)
  Future<void> _initLocalNotifications(void Function(String route) onNavigate) async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          // ❌ DILARANG memakai BuildContext langsung di sini. Gunakan callback navigation (go_router).
          onNavigate(response.payload!);
        }
      },
    );
  }

  // 2. Setup Message Handlers (Foreground, Background Click, Terminated Click)
  void _setupMessageHandlers(void Function(String route) onNavigate) {
    // A. Foreground Message (Aplikasi sedang aktif)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final route = message.data['route'] ?? '/';
      
      // ⚠️ PERBEDAAN PLATFORM:
      // Android: Perlu Notification Details & Importance.max agar pop-up banner melayang muncul.
      // iOS: Banner foreground diatur secara native via presentationOptions.
      const androidDetails = AndroidNotificationDetails(
        'pengumuman_channel_v2',
        'Pengumuman Kampus',
        channelDescription: 'Channel Notifikasi Kampus',
        importance: Importance.max,
        priority: Priority.high,
      );

      _localNotifications.show(
        id: message.hashCode,
        title: message.notification?.title ?? 'Notifikasi Baru',
        body: message.notification?.body ?? '',
        notificationDetails: const NotificationDetails(android: androidDetails),
        payload: route,
      );
    });

    // B. Background Click (Aplikasi ada di background & pengguna mengetuk notifikasi)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final route = message.data['route'];
      if (route != null && route.isNotEmpty) {
        onNavigate(route);
      }
    });

    // C. Terminated Click (Aplikasi mati/ditutup total)
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        final route = message.data['route'];
        if (route != null && route.isNotEmpty) {
          onNavigate(route);
        }
      }
    });
  }

  // 3. Topic Subscription
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
    debugPrint("Subscribed to topic: $topic");
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
    debugPrint("Unsubscribed from topic: $topic");
  }
}
```
