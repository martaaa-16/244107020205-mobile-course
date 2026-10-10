import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../data/api_client.dart';
import 'auth_provider.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final store = ref.watch(tokenStoreProvider);
  final auth = ref.watch(authRepositoryProvider);
  return buildApiClient(store, auth);
});

final fcmTokenProvider =
    NotifierProvider<FcmTokenNotifier, String?>(FcmTokenNotifier.new);

class FcmTokenNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setToken(String token) {
    state = token;
  }
}
