import 'package:chopper/chopper.dart';

import '../../utils/server_url_utils.dart';

const _probeTimeout = Duration(seconds: 10);

/// Determine to connect using https or http (https will be priority)
Future<String?> resolveServerUrl(String raw) async {
  final candidates = serverUrlCandidates(raw);
  final reachable = await Future.wait(candidates.map(isServerReachable));

  // Candidates come back most preferred first, so the first hit wins.
  for (var i = 0; i < candidates.length; i++) {
    if (reachable[i]) return candidates[i];
  }

  return null;
}

/// Pings [baseUrl] to confirm the server is reachable.
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
