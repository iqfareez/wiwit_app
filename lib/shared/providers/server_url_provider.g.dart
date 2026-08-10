// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_url_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Wiwit server this device talks to

@ProviderFor(ServerUrl)
final serverUrlProvider = ServerUrlProvider._();

/// The Wiwit server this device talks to
final class ServerUrlProvider
    extends $AsyncNotifierProvider<ServerUrl, String?> {
  /// The Wiwit server this device talks to
  ServerUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverUrlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverUrlHash();

  @$internal
  @override
  ServerUrl create() => ServerUrl();
}

String _$serverUrlHash() => r'32e3cc041e501484a9e4ba8bdd232d1fcb91187a';

/// The Wiwit server this device talks to

abstract class _$ServerUrl extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The server URL last cleared by [ServerUrl.clear]. Stored
/// in memory only.

@ProviderFor(LastServerUrl)
final lastServerUrlProvider = LastServerUrlProvider._();

/// The server URL last cleared by [ServerUrl.clear]. Stored
/// in memory only.
final class LastServerUrlProvider
    extends $NotifierProvider<LastServerUrl, String?> {
  /// The server URL last cleared by [ServerUrl.clear]. Stored
  /// in memory only.
  LastServerUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastServerUrlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastServerUrlHash();

  @$internal
  @override
  LastServerUrl create() => LastServerUrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$lastServerUrlHash() => r'cb2269f95fd957bb61448d37fe0c4863cf25717c';

/// The server URL last cleared by [ServerUrl.clear]. Stored
/// in memory only.

abstract class _$LastServerUrl extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
