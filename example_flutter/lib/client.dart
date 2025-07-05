import 'package:http/http.dart' as http;

/// A custom HTTP client that applies global headers to all requests.
class AppClient extends http.BaseClient {
  final Map<String, String> globalHeaders;
  final http.Client _inner = http.Client();

  AppClient({Map<String, String>? headers}) : globalHeaders = headers ?? {};
  // ovverride other methods if needed
  // You can override other methods like `get`, `post`, etc. if you want to
  // add specific behavior for those methods.
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(globalHeaders);
    return _inner.send(request);
  }
}
