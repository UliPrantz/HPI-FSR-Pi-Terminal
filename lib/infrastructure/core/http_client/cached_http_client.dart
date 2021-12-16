import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:terminal_frontend/infrastructure/core/http_client/response.dart';


/// This class needs an inner [HttpClient] which is used to make the all 
/// the requests under the hood!
/// Most behavior of this class is also copied from the http.BaseClient since
/// there is no protected in dart to hide extended methods.
class CachedHttpClient {
  static final CachedHttpClient _instance = CachedHttpClient._internal();

  Uri? _host;
  Map<String, String>? _headers;
  http.Client? _innerClient;

  Timer? retryTimer;
  final List<http.BaseRequest> failedRequests = [];

  factory CachedHttpClient({
    required http.Client innerClient,
    required Uri uri,
    Map<String, String> headers = const <String, String>{},
  }) {
    _instance._innerClient ??= innerClient;
    _instance._host ??= uri;
    _instance._headers ??= headers;
    return _instance;
  }
  CachedHttpClient._internal();


  Future<Response> get(
    String endpoint, 
    {Map<String, String>? headers, 
    bool retry=false}) =>
      _sendUnstreamed('GET', endpoint, headers, retry);

  Future<Response> post(String endpoint,
          {Map<String, String>? headers, 
          Object? body, 
          Encoding? encoding, 
          bool retry=false}) =>
      _sendUnstreamed('POST', endpoint, headers, retry, body, encoding);

  Future<Response> put(String endpoint,
          {Map<String, String>? headers, 
          Object? body, 
          Encoding? encoding, 
          bool retry=false}) =>
      _sendUnstreamed('PUT', endpoint, headers, retry, body, encoding);

  Future<Response> patch(String endpoint,
          {Map<String, String>? headers, 
          Object? body, 
          Encoding? encoding, 
          bool retry=false}) =>
      _sendUnstreamed('PATCH', endpoint, headers, retry, body, encoding);

  Future<Response> delete(String endpoint,
          {Map<String, String>? headers, 
          Object? body, 
          Encoding? encoding, 
          bool retry=false}) =>
      _sendUnstreamed('DELETE', endpoint, headers, retry, body, encoding);

  /// Sends a non-streaming [Request] and returns a non-streaming [Response].
  Future<Response> _sendUnstreamed(
      String method, 
      String endpoint, 
      Map<String, String>? headers,
      bool retry,
      [body, Encoding? encoding]) async {
    final Uri url = Uri(
      scheme: _host!.scheme,
      host: _host!.host,
      path: endpoint,
    );
    var request = http.Request(method, url);

    if (headers != null) request.headers.addAll(headers);
    if (_headers!.isNotEmpty) request.headers.addAll(_headers!);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      } else {
        throw ArgumentError('Invalid request body "$body".');
      }
    }

    http.Response tmpHttpResponse = 
      await http.Response.fromStream(await send(request, retry));

    if (tmpHttpResponse.body.isNotEmpty) {
      try {
        body = jsonDecode(tmpHttpResponse.body) as dynamic;
      } on FormatException {
        body = tmpHttpResponse.bodyBytes;
      }
    } else {
      body = <String, dynamic>{};
    }

    return Response(
      body: body, 
      statusCode: tmpHttpResponse.statusCode,
      headers: tmpHttpResponse.headers
    );
  }

  Future<http.StreamedResponse> send(http.BaseRequest request, bool retry) async {
    try {
      return _innerClient!.send(request);
    } on http.ClientException {
      if (retry) {
        failedRequests.add(request);
        
        // if a timer is already active reset it
        if (retryTimer != null) {
          retryTimer!.cancel();
        }
        retryTimer = Timer.periodic(const Duration(seconds: 30), periodicRetry);
      }
      rethrow;
    }
  }
  
  void periodicRetry(Timer timer) {
    // cancel the time since out would be reactivated if any request fails
    timer.cancel();

    List<http.BaseRequest> tmpFailedRequests = List.from(failedRequests);
    failedRequests.clear();

    for (http.BaseRequest request in tmpFailedRequests) { 
      send(request, true);
    }
  }
}