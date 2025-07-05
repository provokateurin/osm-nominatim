import 'dart:developer';

import 'package:http/http.dart' as http;

/// An HTTP client that intercepts requests and responses.
///
/// This client wraps another [http.Client] and allows you to:
/// - Add custom headers (e.g., a custom User-Agent)
/// - Log outgoing requests and incoming responses
///
/// Example usage:
/// ```dart
/// var client = InterceptedClient(http.Client());
/// var response = await client.get(Uri.parse('https://example.com'));
/// ```
///
/// All requests made with this client will include the custom User-Agent header
/// and will be logged using [dart:developer]'s [log] function.
class InterceptedClient extends http.BaseClient {
  /// Creates an [InterceptedClient] that wraps the given [http.Client].

  InterceptedClient(this.client, [Map<String, String>? headers]) {
    if (headers != null) {
      _headers = headers;
    }
  }
  final http.Client client;
  Map<String, String>? _headers;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    //  Add a custom header
    request.headers['User-Agent'] = 'osm_nomination flutter /1.0';
    if (_headers != null) {
      request.headers.addAll(_headers!);
    }

    // Example: Log the request
    log('Request: ${request.method} ${request.url}');

    final response = await client.send(request);

    // Example: Log the response status
    log('Response: ${response.statusCode} ${request.url}');

    return response;
  }
}
