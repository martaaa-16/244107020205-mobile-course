import 'package:campus_notify/core/failure.dart';
import 'package:campus_notify/data/token_store.dart';
import 'package:campus_notify/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:campus_notify/features/auth/domain/repositories/auth_repository.dart';
import 'package:campus_notify/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => const AuthRepositoryImpl(),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

final authStateProvider = AsyncNotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final token = await ref.watch(tokenStoreProvider).readAccess();
    return token != null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(loginUseCaseProvider)
          .call(email: email, password: password);

      if (result.failure != null) {
        return Future.error(Failure.fromObject(result.failure!));
      }

      final session = result.session!;
      await ref
          .read(tokenStoreProvider)
          .save(access: session.access, refresh: session.refresh);
      return true;
    });
  }

  Future<void> logout() async {
    await ref.read(tokenStoreProvider).clear();
    ref.invalidateSelf();
  }
}
