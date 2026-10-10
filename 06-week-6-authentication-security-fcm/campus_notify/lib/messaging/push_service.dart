import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

String? pendingDeepLink;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Notifikasi masuk di background: ${message.messageId}");
}

void registerBackgroundHandler() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

class PushService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<bool> requestNotificationPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<void> initLocalNotifications(
    void Function(String route) onNavigate,
  ) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          onNavigate(payload);
        }
      },
    );
  }

  Future<void> initFcmToken({
    required Future<void> Function(String token) onToken,
  }) async {
    final token = await _fcm.getToken();
    if (token != null) await onToken(token);

    _fcm.onTokenRefresh.listen((newToken) {
      onToken(newToken);
    });

    await _fcm.subscribeToTopic('pengumuman-kampus');
  }

  void listenForeground(void Function(String route) go) {
    FirebaseMessaging.onMessage.listen((message) async {
      final route = message.data['route'] ?? '/';

      const androidDetails = AndroidNotificationDetails(
        'pengumuman_channel_v2', // Ganti ID agar Android membuat kanal baru
        'Pengumuman Kampus',
        channelDescription: 'Kanal untuk notifikasi pengumuman',
        importance: Importance.max, // Wajib MAX untuk pop-up melayang
        priority: Priority.high, // Wajib HIGH
      );

      await _localNotifications.show(
        id: message.hashCode,
        title: message.notification?.title ?? 'Pengumuman',
        body: message.notification?.body ?? '',
        notificationDetails: const NotificationDetails(android: androidDetails),
        payload: route,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final route = message.data['route'];
      if (route != null && route.isNotEmpty) {
        go(route);
      }
    });
  }

  Future<void> handleTerminated(void Function(String route) go) async {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      final route = initial.data['route'];
      if (route != null && route.isNotEmpty) {
        go(route);
      }
    }
  }

  Future<void> initialize({
    required Future<void> Function(String token) onToken,
    required void Function(String route) onNavigate,
  }) async {
    await requestNotificationPermission();
    await initLocalNotifications(onNavigate);
    await initFcmToken(onToken: onToken);

    listenForeground(onNavigate);
    await handleTerminated(onNavigate);
  }
}
