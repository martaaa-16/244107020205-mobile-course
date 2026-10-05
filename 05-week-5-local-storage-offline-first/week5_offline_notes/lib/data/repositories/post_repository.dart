import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

import '../local/db.dart';
import '../models/post.dart';

class PostRepository {
  PostRepository({Dio? dio, Future<Database> Function()? openDb})
    : _dio =
          dio ??
          Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com')),
      _openDb = openDb ?? openNotesDb;

  final Dio _dio;
  final Future<Database> Function() _openDb;

  Future<List<Post>> readCachedPosts() async {
    final db = await _openDb();
    final rows = await db.query('cached_posts', orderBy: 'id ASC');
    return rows
        .map(
          (row) => Post.fromJson(
            jsonDecode(row['payload']! as String) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<Post>> fetchPosts() async {
    final response = await _dio.get<List<dynamic>>('/posts');
    final data = response.data ?? const <dynamic>[];
    return data.whereType<Map<String, dynamic>>().map(Post.fromJson).toList();
  }

  Future<void> saveCachedPosts(List<Post> posts) async {
    final db = await _openDb();
    await db.transaction((txn) async {
      await txn.delete('cached_posts');
      final batch = txn.batch();
      for (final post in posts) {
        batch.insert('cached_posts', {
          'id': post.id,
          'payload': jsonEncode(post.toJson()),
          'cached_at': DateTime.now().toIso8601String(),
        });
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> refreshPostsInBackground() async {
    try {
      final posts = await fetchPosts();
      await saveCachedPosts(posts);
    } on DioException {
      // Offline refresh is best effort; keep showing the existing cache.
    }
  }

  Future<List<Post>> loadPostsCacheFirst({void Function()? onRefresh}) async {
    final cached = await readCachedPosts();
    refreshPostsInBackground().then((_) {
      onRefresh?.call();
    });
    return cached;
  }
}
