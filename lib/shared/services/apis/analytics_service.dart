import 'package:chopper/chopper.dart';

import '../../models/wiwit_api/analytics/txn_overview_response.dart';

part 'analytics_service.chopper.g.dart';

@ChopperApi(baseUrl: '/api/v1/analytics')
abstract class AnalyticsService extends ChopperService {
  static AnalyticsService create([ChopperClient? client]) =>
      _$AnalyticsService(client);

  /// Get analytics overview
  /// [month] must be in Y-m format. Example: '2026-08'
  @GET(path: '/overview', dateFormat: .date)
  Future<Response<TxnOverviewResponse>> getOverview({
    @Query('month') String? month,
  });
}
