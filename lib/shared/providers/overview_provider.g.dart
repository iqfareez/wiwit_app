// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The analytics overview widget for the given [month]

@ProviderFor(txnOverview)
final txnOverviewProvider = TxnOverviewFamily._();

/// The analytics overview widget for the given [month]

final class TxnOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<TxnOverviewResponse>,
          TxnOverviewResponse,
          FutureOr<TxnOverviewResponse>
        >
    with
        $FutureModifier<TxnOverviewResponse>,
        $FutureProvider<TxnOverviewResponse> {
  /// The analytics overview widget for the given [month]
  TxnOverviewProvider._({
    required TxnOverviewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'txnOverviewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$txnOverviewHash();

  @override
  String toString() {
    return r'txnOverviewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TxnOverviewResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TxnOverviewResponse> create(Ref ref) {
    final argument = this.argument as String;
    return txnOverview(ref, month: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TxnOverviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$txnOverviewHash() => r'41cac805b8ee5279eb4bd8c6648e5fe0a209ab88';

/// The analytics overview widget for the given [month]

final class TxnOverviewFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TxnOverviewResponse>, String> {
  TxnOverviewFamily._()
    : super(
        retry: null,
        name: r'txnOverviewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The analytics overview widget for the given [month]

  TxnOverviewProvider call({required String month}) =>
      TxnOverviewProvider._(argument: month, from: this);

  @override
  String toString() => r'txnOverviewProvider';
}
