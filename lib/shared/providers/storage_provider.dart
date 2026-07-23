import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_provider.g.dart';

/// Where the bearer token lives. Kept behind a provider so tests can swap it
/// for a fake without reaching into the widgets that use it.
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) => const FlutterSecureStorage();

/// Where non-sensitive preferences (server URL, theme) live.
@Riverpod(keepAlive: true)
SharedPreferencesAsync preferences(Ref ref) => SharedPreferencesAsync();
