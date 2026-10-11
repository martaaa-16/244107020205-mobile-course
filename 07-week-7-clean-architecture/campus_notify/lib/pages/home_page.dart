import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/fcm_provider.dart';
import '../routes.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fcmToken = ref.watch(fcmTokenProvider);
    final truncatedToken = (fcmToken != null && fcmToken.length > 12)
        ? '${fcmToken.substring(0, 12)}...'
        : (fcmToken ?? 'Belum tersedia');

    final announcements = [
      {'id': '1', 'title': 'Jadwal Ujian Akhir Semester', 'date': '2026-10-10'},
      {'id': '2', 'title': 'Pengumuman Beasiswa Kampus', 'date': '2026-10-15'},
      {'id': '3', 'title': 'Workshop Flutter & Firebase', 'date': '2026-10-20'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Kampus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner Info Debug Token FCM (Terpotong untuk keperluan laporan)
          Card(
            color: Colors.deepPurple.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.deepPurple.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bug_report, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        'Debug Status Token FCM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Token: $truncatedToken',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Catatan: Token ditampilkan terpotong (12 karakter pertama + ...) sesuai ketentuan laporan.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pengumuman Terkini',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...announcements.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                leading: const Icon(Icons.campaign, color: Colors.deepPurple),
                title: Text(item['title']!),
                subtitle: Text('Tanggal: ${item['date']}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.go(AppRoutes.announcementDetail(item['id']!));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
