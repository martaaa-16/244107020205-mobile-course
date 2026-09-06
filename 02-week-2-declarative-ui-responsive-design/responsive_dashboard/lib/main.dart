import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kWideBreakpoint = 700;

void main() {
  runApp(const AcademicOverviewApp());
}

class AcademicOverviewApp extends StatefulWidget {
  const AcademicOverviewApp({super.key});

  @override
  State<AcademicOverviewApp> createState() => _AcademicOverviewAppState();
}

class _AcademicOverviewAppState extends State<AcademicOverviewApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),

      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      home: AcademicOverviewPage(
        isDark: isDark,
        onDarkChanged: (value) {
          setState(() {
            isDark = value;
          });
        },
      ),
    );
  }
}

class AcademicOverviewPage extends StatelessWidget {
  const AcademicOverviewPage({
    super.key,
    required this.isDark,
    required this.onDarkChanged,
  });

  final bool isDark;
  final ValueChanged<bool> onDarkChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Akademik'),
        actions: [
          Semantics(
            label: 'Mode gelap',
            hint: 'Aktifkan atau nonaktifkan mode gelap',
            child: Row(
              children: [
                Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                const SizedBox(width: 4),
                CupertinoSwitch(value: isDark, onChanged: onDarkChanged),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= kWideBreakpoint;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER PROFIL
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: colorScheme.primary,
                        child: Icon(Icons.person, color: colorScheme.onPrimary),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Marta Prama Daniswara',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '244107020205 • TI-3D',
                              style: theme.textTheme.bodyMedium,
                            ),
                            Text(
                              'D-IV Teknik Informatika',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Text('Informasi Akademik', style: theme.textTheme.titleLarge),

                const SizedBox(height: 12),

                // KARTU INFORMASI
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isWide ? 2 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isWide ? 3.2 : 3.5,
                  children: [
                    Semantics(
                      label: 'Tugas, 4 tugas',
                      child: InfoCard(
                        title: 'Tugas',
                        value: '4',
                        icon: Icons.assignment,
                      ),
                    ),

                    Semantics(
                      label: 'Kehadiran, 100 persen',
                      child: InfoCard(
                        title: 'Kehadiran',
                        value: '100%',
                        icon: Icons.event_available,
                      ),
                    ),

                    Semantics(
                      label: 'IPK saat ini, 3,71',
                      child: InfoCard(
                        title: 'IPK Saat Ini',
                        value: '3.71',
                        icon: Icons.school,
                      ),
                    ),

                    Semantics(
                      label: 'Tugas Selesai, 10 tugas selesai',
                      child: InfoCard(
                        title: 'Tugas Selesai',
                        value: '10',
                        icon: Icons.check_circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// WIDGET REUSABLE
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: colorScheme.primary),

            const SizedBox(width: 16),

            Expanded(child: Text(title, style: theme.textTheme.titleMedium)),

            Text(value, style: theme.textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
