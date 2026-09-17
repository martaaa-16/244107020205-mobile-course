import 'package:dio/dio.dart';

import '../models/comment.dart';

/// Loads comments through the shared Dio client.
class CommentRepository {
  /// Receives the centrally configured Dio client.
  CommentRepository(this._dio);

  final Dio _dio;

  /// Fetches comments belonging to one post.
  Future<List<Comment>> fetchComments(int postId) async {
    final response = await _dio.get<List>(
      '/comments',
      queryParameters: {'postId': postId},
    );
    final data = response.data ?? [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(Comment.fromJson)
        .toList();
  }
}
