import 'core/format.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String announcement = '/pengumuman/:id';

  static String announcementDetail(String id) => '/pengumuman/$id';
}

String routeFromMessage(Map<String, dynamic> data) {
  return normalizeRoute(data['route']?.toString(), fallback: AppRoutes.home);
}
