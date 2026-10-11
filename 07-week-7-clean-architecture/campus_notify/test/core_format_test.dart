import 'package:campus_notify/core/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('core format helpers', () {
    test('normalizes route values without a leading slash', () {
      expect(normalizeRoute(null), '/');
      expect(normalizeRoute('pengumuman/3'), '/pengumuman/3');
      expect(normalizeRoute('/pengumuman/3'), '/pengumuman/3');
    });

    test('extracts route parameters from a known announcement path', () {
      expect(parseRouteParameter('/pengumuman/3', 'id'), '3');
      expect(parseRouteParameter('/pengumuman/abc-9', 'id'), 'abc-9');
      expect(parseRouteParameter('/', 'id'), isNull);
    });

    test('formats a raw date string into a readable display value', () {
      expect(formatDisplayDate('2026-10-10'), '10 Okt 2026');
      expect(formatDisplayDate(DateTime(2026, 1, 15)), '15 Jan 2026');
      expect(formatDisplayDate(''), 'Tanggal tidak tersedia');
    });
  });
}
