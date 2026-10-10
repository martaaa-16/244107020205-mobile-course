import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

String? pendingDeepLink;

class PushService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // 1. Meminta izin notifikasi
  Future<bool> requestNotificationPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  // 2. Inisialisasi notifikasi lokal & handler klik
  Future<void> initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        pendingDeepLink = response.payload;
      },
    );
  }

  // 3. Token Lifecycle: Ambil token, kirim ke backend, dan pantau perubahan token
  Future<void> initFcmToken({
    required Future<void> Function(String token) onToken,
  }) async {
    // 1. Ambil token saat ini dan kirim ke backend
    final token = await _fcm.getToken();

    print("==================================================");
    print("FCM TOKEN KAMU: $token");
    print("==================================================");

    if (token != null) await onToken(token);

    // 2. Listener jika token berubah (reinstall, clear data, rotasi keamanan)
    _fcm.onTokenRefresh.listen((newToken) {
      print("FCM TOKEN DIPERBARUI: $newToken");
      onToken(newToken);
      });

    // 3. Berlangganan ke topik kampus
    await _fcm.subscribeToTopic('pengumuman-kampus');
  }

  // 4. Inisialisasi utama aplikasi
  Future<void> initialize({
    required Future<void> Function(String token) onToken,
  }) async {
    await requestNotificationPermission();
    await initLocalNotifications();
    await initFcmToken(onToken: onToken);

    // Listener pesan saat aplikasi sedang dibuka (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _localNotifications.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'campus_channel',
              'Campus Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          payload: message.data['route'],
        );
      }
    });
  }

  Future<String?> getToken() => _fcm.getToken();
}