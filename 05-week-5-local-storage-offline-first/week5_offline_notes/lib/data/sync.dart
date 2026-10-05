import 'package:dio/dio.dart';

import 'repositories/note_repository.dart';
import 'repositories/post_repository.dart';
import 'models/post.dart';

Future<List<Post>> loadPostsCacheFirst(
  PostRepository repository, {
  void Function()? onRefresh,
}) async {
  final cached = await repository.readCachedPosts();
  refreshPostsInBackground(repository).then((_) {
    onRefresh?.call();
  });
  return cached;
}

Future<void> refreshPostsInBackground(PostRepository repository) async {
  try {
    final posts = await repository.fetchPosts();
    await repository.saveCachedPosts(posts);
  } on DioException {
    // Offline refresh is best effort; keep showing the existing cache.
  }
}

Future<int> syncNotes(NoteRepository repo, {bool forceOffline = false}) async {
  if (forceOffline) return 0;

  final dirtyCount = await repo.countDirty();
  if (dirtyCount == 0) return 0;

  await Future.delayed(const Duration(seconds: 1));
  await repo.markAllSynced();
  return dirtyCount;
}