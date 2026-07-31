/// Matches the `http://` / `https://`.
final _httpScheme = RegExp(r'^https?://', caseSensitive: false);

/// Matches any scheme at all. Example: `ftp://x`.
final _anyScheme = RegExp(r'^[a-zA-Z][a-zA-Z0-9+.\-]*://');

/// Trims whitespace and trailing slashes
String _clean(String raw) {
  final url = raw.trim();

  final scheme = _anyScheme.stringMatch(url) ?? '';
  var rest = url.substring(scheme.length);
  while (rest.endsWith('/')) {
    rest = rest.substring(0, rest.length - 1);
  }

  return '$scheme$rest';
}

/// The base URLs worth probing for what the user typed, most preferred first.
/// A scheme the user typed is honoured as-is.
List<String> serverUrlCandidates(String raw) {
  final url = _clean(raw);
  if (_anyScheme.hasMatch(url)) return [url];

  return ['https://$url', 'http://$url'];
}

/// Form validator for the server URL field.
String? validateServerUrl(String? raw) {
  if (raw == null || raw.trim().isEmpty) return 'Please enter your server URL';

  final url = _clean(raw);
  if (_anyScheme.hasMatch(url) && !_httpScheme.hasMatch(url)) {
    return 'Only http:// and https:// addresses are supported';
  }

  final uri = Uri.tryParse(serverUrlCandidates(raw).first);
  if (uri == null || uri.host.isEmpty) {
    return "That doesn't look like a server address";
  }

  return null;
}
