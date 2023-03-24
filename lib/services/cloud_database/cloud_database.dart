import 'package:awesome_notes/models/note_model.dart';
import 'package:awesome_notes/services/cloud_database/cloud_exp.dart';
import 'package:awesome_notes/models/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'database_constant.dart' as db_constant;

class CloudDatabase {
  final String userId;
  CloudDatabase({required this.userId});

  // Note service
  Stream<List<Note>> getNotes({bool hidden = false}) {
    return FirebaseFirestore.instance
        .collection(db_constant.user)
        .doc(userId)
        .collection(db_constant.notes)
        .where(db_constant.isHidden, isEqualTo: hidden)
        .orderBy(db_constant.createdAt, descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Note.fromFirebase(doc),
              )
              .toList(),
        );
  }

  Future<Note> _addNote(Note note) async {
    try {
      final uuid = const Uuid().v1();
      note.id = uuid;
      await FirebaseFirestore.instance
          .collection(db_constant.user)
          .doc(userId)
          .collection(db_constant.notes)
          .doc(note.id)
          .set(note.toMap());
      return note;
    } on Exception catch (e) {
      throw CloudExp(e.toString());
    }
  }

  Future<void> _updateNote(Note note) async {
    try {
      await FirebaseFirestore.instance
          .collection(db_constant.user)
          .doc(userId)
          .collection(db_constant.notes)
          .doc(note.id)
          .update(note.toMap());
    } on Exception catch (e) {
      throw CloudExp(e.toString());
    }
  }

  Future<Note> createOrUpdateNote(Note note) async {
    try {
      if (note.id.isEmpty) {
        note = await _addNote(note);
      } else {
        await _updateNote(note);
      }
      return note;
    } on Exception catch (e) {
      throw CloudExp(e.toString());
    }
  }

  Future<void> deleteNote(Note note) async {
    try {
      await FirebaseFirestore.instance
          .collection(db_constant.user)
          .doc(userId)
          .collection(db_constant.notes)
          .doc(note.id)
          .delete();
    } on Exception catch (e) {
      throw CloudExp(e.toString());
    }
  }

  Future<void> deleteAllNotes({bool hidden = false}) async {
    try {
      await FirebaseFirestore.instance
          .collection(db_constant.user)
          .doc(userId)
          .collection(db_constant.notes)
          .where(db_constant.isHidden, isEqualTo: hidden)
          .get()
          .then(
            (value) =>
                value.docs.toList().forEach((doc) => doc.reference.delete()),
          );
    } on Exception catch (e) {
      throw CloudExp(e.toString());
    }
  }

  // User data service

  Future<void> addUserData(UserData user) async {
    try {
      await FirebaseFirestore.instance
          .collection(db_constant.user)
          .doc(userId)
          .set(user.toMap());
    } on Exception catch (e) {
      throw CloudExp(e.toString());
    }
  }

  Future<void> updateUserData(UserData user) async {
    await FirebaseFirestore.instance
        .collection(db_constant.user)
        .doc(userId)
        .update(user.toMap());
  }

  Future<void> updateName(String name) async {
    try {
      await FirebaseFirestore.instance
          .collection(db_constant.user)
          .doc(userId)
          .update({db_constant.name: name});
    } on Exception catch (e) {
      throw CloudExp(e.toString());
    }
  }

  Future<void> updateProfilePic(String profilePic) async {
    try {
      await FirebaseFirestore.instance
          .collection(db_constant.user)
          .doc(userId)
          .update({'profilePicUrl': profilePic});
    } on Exception catch (e) {
      throw CloudExp(e.toString());
    }
  }

  Future<UserData> getUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(db_constant.user)
          .doc(userId)
          .get();
      return UserData.fromSnapshot(doc);
    } on Exception catch (e) {
      throw CloudExp(e.toString());
    }
  }

  factory CloudDatabase.currentUser() {
    final id = FirebaseAuth.instance.currentUser!.uid;
    return CloudDatabase(userId: id);
  }
}
