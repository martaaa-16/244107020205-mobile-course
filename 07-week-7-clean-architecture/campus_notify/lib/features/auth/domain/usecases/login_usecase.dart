import '../../../../core/failure.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<({AuthSession? session, Failure? failure})> call({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || !trimmedEmail.contains('@')) {
      return (
        session: null,
        failure: const LocalFailure('Email tidak valid (harus mengandung @)'),
      );
    }

    if (password.length < 6) {
      return (
        session: null,
        failure: const LocalFailure('Kata sandi minimal 6 karakter'),
      );
    }

    return _repository.login(email: trimmedEmail, password: password);
  }
}
