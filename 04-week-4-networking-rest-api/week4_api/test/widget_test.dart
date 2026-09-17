// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:week4_api/main.dart';
import 'package:week4_api/data/paged_posts.dart';
import 'package:week4_api/data/models/post.dart';

class FakePagedPostsNotifier extends PagedPostsNotifier {
  @override
  PagedPostsState build() => const PagedPostsState(
    items: [Post(id: 1, userId: 1, title: 'Test post', body: 'Test body')],
    page: 1,
    hasMore: false,
  );
}

void main() {
  testWidgets('shows the paged posts page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pagedPostsProvider.overrideWith(FakePagedPostsNotifier.new),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Posts Paged'), findsOneWidget);
  });
}
