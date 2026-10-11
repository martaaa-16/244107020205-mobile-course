const List<String> _monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

String normalizeRoute(String? route, {String fallback = '/'}) {
  final value = (route ?? '').trim();
  if (value.isEmpty) return fallback;

  final normalized = value.startsWith('/') ? value : '/$value';
  return normalized.isEmpty ? fallback : normalized;
}

String? parseRouteParameter(String? route, String key) {
  final normalized = normalizeRoute(route);
  final segments = normalized
      .split('/')
      .where((segment) => segment.isNotEmpty)
      .toList();

  if (segments.length >= 2 && segments.first == 'pengumuman' && key == 'id') {
    return segments[1];
  }

  for (var i = 0; i < segments.length - 1; i++) {
    if (segments[i] == key) {
      return segments[i + 1];
    }
  }

  return null;
}

String formatDisplayDate(Object? value) {
  if (value == null) return 'Tanggal tidak tersedia';

  final text = value.toString().trim();
  if (text.isEmpty) return 'Tanggal tidak tersedia';

  final parsed = value is DateTime ? value : DateTime.tryParse(text);
  if (parsed == null) return text;

  return '${parsed.day} ${_monthNames[parsed.month - 1]} ${parsed.year}';
}
