import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/comment.dart';
import 'providers.dart';
import 'repositories/comment_repository.dart';

/// Provides a repository that uses the shared Dio configuration.
final commentRepositoryProvider = Provider<CommentRepository>(
  (ref) => CommentRepository(ref.watch(dioProvider)),
);

/// Loads comments for the post ID supplied to the provider family.
class CommentsNotifier extends AsyncNotifier<List<Comment>> {
  CommentsNotifier(this.postId);

  final int postId;

  /// Riverpod calls this method when the provider is watched.
  @override
  Future<List<Comment>> build() {
    final repository = ref.watch(commentRepositoryProvider);
    return repository.fetchComments(postId);
  }
}

/// Exposes loading, data, and automatic AsyncError states to the UI.
final commentsProvider =
    AsyncNotifierProvider.family<CommentsNotifier, List<Comment>, int>(
      CommentsNotifier.new,
      retry: (retryCount, error) => null,
    );
