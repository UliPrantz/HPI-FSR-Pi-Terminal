import 'dart:typed_data';

class Response {
  final Object _body;
  final Map<String, String> headers;
  final int statusCode;

  Response({
    required Object body, 
    required this.statusCode, 
    required this.headers
  }) : _body = body;

  Map<String, dynamic> get bodyAsMap =>
      _body is Map<String, dynamic> ? _body as Map<String, dynamic> : throw ArgumentError("body: $_body is not Map");

  List<dynamic> get bodyAsList => _body is List
      ? _body as List<dynamic>
      : throw ArgumentError("body: $_body is not "
          "List");

  Uint8List get bodyAsBytes => _body is Uint8List
      ? _body as Uint8List
      : throw ArgumentError("body: $_body is not "
          "Uint8List");

  @override
  String toString() {
    return 'statusCode : $statusCode\nheaders: $headers\n body: $_body';
  }
}