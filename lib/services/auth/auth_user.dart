// import 'package:firebase_auth/firebase_auth.dart';

// class AuthUser {
//   final String id;
//   final String email;
//   final String name;
//   final bool isVerified;
//   AuthUser(
//       {required this.id,
//       required this.name,
//       required this.email,
//       required this.isVerified});

//   factory AuthUser.fromFirebase(User user) {
//     return AuthUser(
//         id: user.uid,
//         name: user.displayName ?? 'User name',
//         email: user.email!,
//         isVerified: user.emailVerified);
//   }

  

//   Future<void> reload() async {
//     FirebaseAuth.instance.currentUser!.reload();
//   }
// }
