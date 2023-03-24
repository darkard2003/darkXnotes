class CloudExp implements Exception {
  final String message;
  CloudExp(this.message);
  @override
  String toString() => message;
}
