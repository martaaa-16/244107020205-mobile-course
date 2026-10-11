import 'package:campus_notify/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:campus_notify/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth login use case', () {
    test('rejects invalid email format', () async {
      final useCase = LoginUseCase(const AuthRepositoryImpl());

      final result = await useCase.call(
        email: 'invalid-email',
        password: 'password123',
      );

      expect(result.session, isNull);
      expect(result.failure, isNotNull);
    });

    test('returns a session for valid credentials', () async {
      final useCase = LoginUseCase(const AuthRepositoryImpl());

      final result = await useCase.call(
        email: 'user@campus.ac.id',
        password: 'password123',
      );

      expect(result.failure, isNull);
      expect(result.session, isNotNull);
      expect(
        result.session!.access,
        contains('mock-access-for-user@campus.ac.id'),
      );
    });
  });
}
