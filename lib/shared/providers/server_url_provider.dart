import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants.dart';
import 'storage_provider.dart';

part 'server_url_provider.g.dart';

/// The Wiwit server this device talks to
@Riverpod(keepAlive: true)
class ServerUrl extends _$ServerUrl {
  @override
  Future<String?> build() =>
      ref.watch(preferencesProvider).getString(kStoreServerUrl);

  Future<void> set(String url) async {
    await ref.read(preferencesProvider).setString(kStoreServerUrl, url);

    state = AsyncData(url);
    ref.read(lastServerUrlProvider.notifier).set(null);
  }

  /// Forgets the server, which tears the Chopper client down with it.
  Future<void> clear() async {
    ref.read(lastServerUrlProvider.notifier).set(state.value);
    await ref.read(preferencesProvider).remove(kStoreServerUrl);

    state = const AsyncData(null);
  }
}

/// The server URL last cleared by [ServerUrl.clear]. Stored
/// in memory only.
@Riverpod(keepAlive: true)
class LastServerUrl extends _$LastServerUrl {
  @override
  String? build() => null;

  void set(String? url) => state = url;
}
