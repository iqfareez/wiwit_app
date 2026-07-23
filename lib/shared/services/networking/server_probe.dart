import 'package:chopper/chopper.dart';

const _probeTimeout = Duration(seconds: 10);

/// Pings [baseUrl] to confirm the server is reachable.
///
/// Any HTTP response (even 401/404) means the host answered, so it counts as
/// reachable. Only connection failures or timeouts return `false`.
///
/// Uses its own throwaway client because it runs during onboarding, before a
/// server URL exists for the shared client to point at.
Future<bool> isServerReachable(String baseUrl) async {
  // TODO: Create an endpoint to verify it's the wiwit instances
  final probe = ChopperClient(baseUrl: Uri.parse(baseUrl));

  try {
    await probe.get(Uri.parse('/')).timeout(_probeTimeout);
    return true;
  } catch (_) {
    return false;
  } finally {
    probe.dispose();
  }
}
