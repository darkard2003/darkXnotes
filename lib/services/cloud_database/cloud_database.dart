import 'package:awesome_notes/models/note_model.dart';
import 'package:awesome_notes/services/cloud_database/cloud_exp.dart';
import 'package:awesome_notes/models/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'database_constant.dart' as db_constant;

class CloudDatabase {
  factory CloudDatabase() => _shared;

  CloudDatabase._getInstance();

  static final _shared = CloudDatabase._getInstance();

  // Note service
  Stream<List<Note>> getNotes(String userId, {bool hidden = false}) {
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
                (doc) => Note.fromMap(doc.data(), doc.id),
              )
              .toList(),
        );
  }

  Future<Note> createNote(Note note, String userId) async {
    try {
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

  Future<void> updateNote(Note note, String userId) async {
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

  Future<void> deleteNote(Note note, String userId) async {
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

  Future<void> deleteAllNotes(String userId, {bool hidden = false}) async {
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
          .doc(user.id)
          .set(user.toMap());
    } on Exception catch (e) {
      throw CloudExp(e.toString());
    }
  }

  Future<void> updateUserData(UserData user) async {
    await FirebaseFirestore.instance
        .collection(db_constant.user)
        .doc(user.id)
        .update(user.toMap());
  }

  Future<UserData?> getUserData(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(db_constant.user)
          .doc(userId)
          .get();

      if (!doc.exists) return null;

      return UserData.fromMap(doc.data()!);
    } on Exception catch (e) {
      throw CloudExp(e.toString());
    }
  }
}
