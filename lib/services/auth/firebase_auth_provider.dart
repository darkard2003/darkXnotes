import 'package:awesome_notes/firebase_options.dart';
import 'package:awesome_notes/models/user_data_model.dart';
import 'package:awesome_notes/services/auth/auth_exp.dart';
import 'package:awesome_notes/services/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notes/services/cloud_database/cloud_database.dart';

class FirebaseAuthProvider implements AppAuthProvider {
  // Making it singleton
  FirebaseAuthProvider._getInstance();
  static final _shared = FirebaseAuthProvider._getInstance();
  factory FirebaseAuthProvider() => _shared;

  CloudDatabase? cloud;

  // Initialise
  Future<void> initialise() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      throw const AuthExp(message: 'Could not initialise firebase');
    }
  }

  // Login
  @override
  Future<UserData> loginWithEmail(
      {required String email, required String password}) async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      final doc = await CloudDatabase.currentUser().getUserData();
      return doc;
    } on FirebaseAuthException catch (e) {
      throw AuthExp(message: e.message!);
    } catch (e) {
      throw AuthExp(message: 'Login error :: ${e.toString()}');
    }
  }

  // Register
  @override
  Future<UserData> registerWithEmail(
      {required String email, required String password}) async {
    try {
      final auth = FirebaseAuth.instance;
      final result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = result.user!;
      return UserData.fromAuthUser(user);
    } on FirebaseAuthException catch (e) {
      throw AuthExp(message: e.message!);
    } catch (e) {
      throw AuthExp(message: 'Error :: ${e.toString()}');
    }
  }

  // Email verification
  @override
  Future<void> sendVerificationEmail() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    await user.sendEmailVerification();
  }

  // Sign Out
  @override
  Future<void> logOut() async {
    final auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  // Get User
  @override
  Future<UserData?> get user async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    } else {
      cloud ??= CloudDatabase.currentUser();
      return await cloud!.getUserData();
    }
  }
}
