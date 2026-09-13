import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/wiwit_api/analytics/txn_overview_response.dart';
import 'chopper_provider.dart';

part 'overview_provider.g.dart';

/// The analytics overview widget for the given [month]
@riverpod
Future<TxnOverviewResponse> txnOverview(Ref ref, {required String month}) {
  return ref.watch(analyticsServiceProvider).getOverview(month: month);
}
