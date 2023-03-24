class AuthExp implements Exception {
  final String message;
  const AuthExp({required this.message});
  @override
  String toString() => message;
}
