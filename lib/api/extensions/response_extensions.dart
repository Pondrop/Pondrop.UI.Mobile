import 'package:http/http.dart';

class HttpRequestException implements Exception {
  const HttpRequestException(this.method, this.url, this.statusCode, this.body);

  final String method;
  final String url;

  final int statusCode;
  final String body;
}

extension ResponseExtensions on Response {
  void ensureSuccessStatusCode() {
    if (statusCode >= 200 && statusCode <= 299) {
      return;
    }

    throw HttpRequestException(
        request?.method ?? '', request?.url.toString() ?? '', statusCode, body);
  }
}
