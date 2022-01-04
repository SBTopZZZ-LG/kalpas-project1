class Response {
  final int statusCode;
  final String? error;
  final String? result;

  Response({required this.statusCode, this.error, this.result});
}
