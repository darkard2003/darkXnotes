import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/cloud_database/database_constant.dart' as db_constant;

class UserData {
  String name;
  final String email;
  final String id;
  bool isVerified;
  
  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
  });

  factory UserData.fromSnapshot(DocumentSnapshot doc) {
    return UserData(
      id: doc[db_constant.id] as String,
      isVerified: doc[db_constant.isVerified],
      name: doc[db_constant.name] as String,
      email: doc[db_constant.email] as String,
    );
  }

  factory UserData.fromAuthUser(User user) {
    return UserData(
      id: user.uid,
      name: '',
      email: user.email!,
      isVerified: user.emailVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      db_constant.id: id,
      db_constant.isVerified: isVerified,
      db_constant.name: name,
      db_constant.email: email,
    };
  }

  Future<void> sendEmailVerification() async {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  Future<void> reload() async {
    FirebaseAuth.instance.currentUser!.reload();
    // ignore: no_leading_underscores_for_local_identifiers
    final _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (_isVerified != isVerified) {
      isVerified = _isVerified;
    }
  }
}
