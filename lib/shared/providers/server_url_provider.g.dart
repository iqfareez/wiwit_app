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

String _$serverUrlHash() => r'ecf05b92e705def102437eb152b75fcd4f7a0647';

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
