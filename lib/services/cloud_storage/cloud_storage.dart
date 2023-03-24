import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageProvider {
  // make it singleton
  FirebaseStorageProvider._();
  static final FirebaseStorageProvider instance = FirebaseStorageProvider._();
  factory FirebaseStorageProvider() => instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfile(dynamic file, String userId) async {
    final Reference ref = _storage.ref().child('$userId/profile/profile_pic.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}