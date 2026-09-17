import 'package:flutter_test/flutter_test.dart';

import 'package:week4_api/data/models/comment.dart';

void main() {
  test('fromJson uses safe defaults for missing and null fields', () {
    final comment = Comment.fromJson({
      'postId': null,
      'id': 7,
      'name': 'A name',
    });

    expect(comment.postId, 0);
    expect(comment.id, 7);
    expect(comment.name, 'A name');
    expect(comment.email, '');
    expect(comment.body, '');
  });
}
