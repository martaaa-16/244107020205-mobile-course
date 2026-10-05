import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/post.dart';
import 'repositories/post_repository.dart';
import 'sync.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

final postsProvider = FutureProvider<List<Post>>((ref) async {
  final repository = ref.watch(postRepositoryProvider);
  return loadPostsCacheFirst(repository, onRefresh: ref.invalidateSelf);
});
