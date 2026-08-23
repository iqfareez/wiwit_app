// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'analytics_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AnalyticsService extends AnalyticsService {
  _$AnalyticsService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AnalyticsService;

  @override
  Future<Response<TxnOverviewResponse>> getOverview({String? month}) {
    final Uri $url = Uri.parse('/api/v1/analytics/overview');
    final Map<String, dynamic> $params = <String, dynamic>{'month': month};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      dateFormat: DateFormat.date,
    );
    return client.send<TxnOverviewResponse, TxnOverviewResponse>($request);
  }
}
