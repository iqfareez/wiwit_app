import 'package:flutter_test/flutter_test.dart';
import 'package:wiwit_app/shared/utils/server_url_utils.dart';

void main() {
  group('serverUrlCandidates', () {
    test('offers both schemes when the user typed none, https first', () {
      expect(serverUrlCandidates('your-server.com'), [
        'https://your-server.com',
        'http://your-server.com',
      ]);
      // The Android emulator's alias for the host machine.
      expect(serverUrlCandidates('10.0.2.2:43532'), [
        'https://10.0.2.2:43532',
        'http://10.0.2.2:43532',
      ]);
    });

    test('offers both schemes for a localhosts', () {
      expect(serverUrlCandidates('192.168.1.5'), [
        'https://192.168.1.5',
        'http://192.168.1.5',
      ]);
      expect(serverUrlCandidates('localhost:8080'), [
        'https://localhost:8080',
        'http://localhost:8080',
      ]);
    });

    test('honours a scheme the user typed', () {
      expect(serverUrlCandidates('http://10.0.2.2:43532'), [
        'http://10.0.2.2:43532',
      ]);
      expect(serverUrlCandidates('https://192.168.1.5'), [
        'https://192.168.1.5',
      ]);
      expect(serverUrlCandidates('HTTP://10.0.2.2'), ['HTTP://10.0.2.2']);
    });

    test('keeps ports, paths and IPv6 brackets intact', () {
      expect(
        serverUrlCandidates('10.0.2.2:43532/api/v1').last,
        'http://10.0.2.2:43532/api/v1',
      );
      expect(serverUrlCandidates('[::1]:43532').last, 'http://[::1]:43532');
      expect(
        serverUrlCandidates('me@192.168.1.5:8080').last,
        'http://me@192.168.1.5:8080',
      );
    });

    test('trims whitespace and trailing slashes', () {
      expect(
        serverUrlCandidates('  10.0.2.2:43532/  ').last,
        'http://10.0.2.2:43532',
      );
      expect(serverUrlCandidates('https://a.com///'), ['https://a.com']);
      // Trimming must not eat the scheme's own slashes.
      expect(serverUrlCandidates('http://'), ['http://']);
    });
  });

  group('validateServerUrl', () {
    test('accepts IPs, ports and hostnames', () {
      expect(validateServerUrl('10.0.2.2:43532'), isNull);
      expect(validateServerUrl('192.168.1.5'), isNull);
      expect(validateServerUrl('https://wiwit.example.com'), isNull);
      expect(validateServerUrl('http://localhost:8080'), isNull);
    });

    test('rejects empty input', () {
      expect(validateServerUrl(null), isNotNull);
      expect(validateServerUrl('   '), isNotNull);
    });

    test('rejects schemes we cannot talk to', () {
      expect(validateServerUrl('ftp://10.0.2.2'), isNotNull);
      expect(validateServerUrl('ws://10.0.2.2:43532'), isNotNull);
    });

    test('rejects addresses without a usable host', () {
      expect(validateServerUrl('http://'), isNotNull);
      expect(validateServerUrl('https://'), isNotNull);
      expect(validateServerUrl('10.0.2.2:not-a-port'), isNotNull);
    });
  });
}
