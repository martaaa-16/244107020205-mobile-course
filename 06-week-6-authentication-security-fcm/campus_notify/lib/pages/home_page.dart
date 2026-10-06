import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final item = announcements[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              leading: const Icon(Icons.campaign, color: Colors.deepPurple),
              title: Text(item['title']!),
              subtitle: Text('Tanggal: ${item['date']}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.go('/pengumuman/${item['id']}');
              },
            ),
          );
        },
      ),
    );
  }
}
