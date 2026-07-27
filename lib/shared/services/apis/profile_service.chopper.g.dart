// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'profile_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ProfileService extends ProfileService {
  _$ProfileService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ProfileService;

  @override
  Future<Response<ProfileResponse>> getProfile() {
    final Uri $url = Uri.parse('/api/v1/profile');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<ProfileResponse, ProfileResponse>($request);
  }
}
