// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'instance_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$InstanceService extends InstanceService {
  _$InstanceService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = InstanceService;

  @override
  Future<Response<InstanceResponse>> getInstance() {
    final Uri $url = Uri.parse('/api/v1/instance');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<InstanceResponse, InstanceResponse>($request);
  }
}
