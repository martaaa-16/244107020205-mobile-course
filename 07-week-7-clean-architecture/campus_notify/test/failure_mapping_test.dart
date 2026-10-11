import 'package:campus_notify/core/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps raw exceptions to friendly user-facing failure messages', () {
    final failure = Failure.fromObject(
      Exception('DatabaseException: table missing'),
    );

    expect(failure.message, isNotEmpty);
    expect(failure.message, isNot(contains('DatabaseException')));
    expect(failure.message, isNot(contains('Exception:')));
  });

  test('keeps a domain failure message untouched', () {
    const failure = LocalFailure('Email tidak valid');

    expect(Failure.fromObject(failure).message, 'Email tidak valid');
  });
}
