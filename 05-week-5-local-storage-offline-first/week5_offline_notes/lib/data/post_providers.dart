import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/post.dart';
import 'repositories/post_repository.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

final postsProvider = FutureProvider<List<Post>>((ref) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.loadPostsCacheFirst(onRefresh: ref.invalidateSelf);
});
