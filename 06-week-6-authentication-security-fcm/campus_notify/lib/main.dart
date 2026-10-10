import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';

import 'messaging/push_service.dart';
import 'pages/announcement_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/auth_provider.dart';
import 'providers/fcm_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final loggedIn = authState.value ?? false;
      final goingToLogin = state.matchedLocation == '/login';

      if (!loggedIn && !goingToLogin) return '/login';
      if (loggedIn && goingToLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/pengumuman/:id',
        builder: (context, state) =>
            AnnouncementPage(id: state.pathParameters['id'] ?? ''),
      ),
    ],
  );
});

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Memanggil inisialisasi push notification setelah frame pertama selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initPushNotifications();
    });
  }

  Future<void> _initPushNotifications() async {
    final pushService = PushService();
    final dio = ref.read(apiClientProvider);

    await pushService.initialize(
      onToken: (token) async {
        debugPrint('FCM Token: $token');

        // 1. Simpan token ke NotifierProvider untuk UI Debug
        ref.read(fcmTokenProvider.notifier).setToken(token);

        // 2. Pengiriman token ke backend sesuai spesifikasi[cite: 5]
        try {
          await dio.post(
            '/devices',
            data: {'fcm_token': token, 'platform': 'android'},
          );
          debugPrint('Token FCM berhasil dikirim ke backend.');
        } catch (e) {
          debugPrint('Simulasi/Gagal pengiriman token ke backend: $e');
        }
      },
    );

    // 3. Cek jika ada pendingDeepLink dari notifikasi lokal saat diklik
    if (pendingDeepLink != null && pendingDeepLink!.isNotEmpty) {
      final router = ref.read(routerProvider);
      router.go(pendingDeepLink!);
      pendingDeepLink = null; // Reset setelah digunakan
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Campus Notify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
