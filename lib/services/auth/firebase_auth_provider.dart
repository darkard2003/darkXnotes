import 'package:awesome_notes/models/user_data_model.dart';
import 'package:awesome_notes/services/auth/auth_exp.dart';
import 'package:awesome_notes/services/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthProvider implements AppAuthProvider {
  // Making it singleton
  FirebaseAuthProvider._getInstance();

  static final _shared = FirebaseAuthProvider._getInstance();

  factory FirebaseAuthProvider() => _shared;

  final _auth = FirebaseAuth.instance;

  // Login
  @override
  Future<String> loginWithEmail(
      {required String email, required String password}) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw AuthExp(message: e.message!);
    } catch (e) {
      throw AuthExp(message: 'Login error :: ${e.toString()}');
    }
  }

  // Register
  @override
  Future<UserData> registerWithEmail({
    required String email,
    required String password,
    String name = '',
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = result.user!;
      await user.updateDisplayName(name);
      return UserData(
        id: user.uid,
        email: user.email!,
        name: name,
        isVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthExp(message: e.message!);
    } catch (e) {
      throw AuthExp(message: 'Error :: ${e.toString()}');
    }
  }

  // Email verification
  @override
  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser!;
    await user.sendEmailVerification();
  }

  // Sign Out
  @override
  Future<void> logOut() async {
    await _auth.signOut();
  }

  // Get User
  @override
  Future<UserData?> get user async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return UserData(
      id: user.uid,
      email: user.email!,
      name: user.displayName ?? '',
      isVerified: user.emailVerified,
    );
  }

  @override
  Future<UserData?> refreshUser(UserData user) async {
    var fireuser = FirebaseAuth.instance.currentUser;
    if (fireuser == null) {
      return null;
    }

    return user.copyWith(
      id: fireuser.uid,
      email: fireuser.email!,
      isVerified: fireuser.emailVerified,
    );
  }

  @override
  Future<void> sendEmailVerification(UserData user) async {
    var fireuser = FirebaseAuth.instance.currentUser;
    if (fireuser == null) {
      return;
    }
    await fireuser.sendEmailVerification();
  }
}
