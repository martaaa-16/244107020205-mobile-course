import 'package:campus_notify/core/failure.dart';
import 'package:campus_notify/features/auth/domain/entities/auth_session.dart';
import 'package:campus_notify/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl();

  @override
  Future<({AuthSession? session, Failure? failure})> login({
    required String email,
    required String password,
  }) async {
    try {
      final trimmedEmail = email.trim();
      if (trimmedEmail.isEmpty || !trimmedEmail.contains('@')) {
        return (
          session: null,
          failure: const LocalFailure('Email atau kata sandi tidak valid'),
        );
      }

      if (password.length < 6) {
        return (
          session: null,
          failure: const LocalFailure('Email atau kata sandi tidak valid'),
        );
      }

      await Future.delayed(const Duration(milliseconds: 500));

      return (
        session: AuthSession(
          access: 'mock-access-for-$trimmedEmail',
          refresh: 'mock-refresh-for-$trimmedEmail',
        ),
        failure: null,
      );
    } catch (error) {
      return (session: null, failure: Failure.fromObject(error));
    }
  }

  @override
  Future<({String? token, Failure? failure})> refresh(
    String refreshToken,
  ) async {
    try {
      final token = refreshToken.trim();
      if (token.isEmpty) {
        return (
          token: null,
          failure: const LocalFailure('Refresh token hilang'),
        );
      }

      await Future.delayed(const Duration(milliseconds: 300));

      return (
        token: 'mock-access-renewed-${DateTime.now().millisecondsSinceEpoch}',
        failure: null,
      );
    } catch (error) {
      return (token: null, failure: Failure.fromObject(error));
    }
  }
}
