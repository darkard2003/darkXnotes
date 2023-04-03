import 'package:awesome_notes/services/encryption/cypher.dart';
import 'todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'text_note_model.dart';
import 'package:awesome_notes/services/cloud_database/database_constant.dart'
    as db_constant;

export 'text_note_model.dart';
export 'todo_model.dart';

enum Type {
  text,
  todo,
}

abstract class Note {
  String id;
  Type type;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  bool isHidden;
  var _cypher = Cypher();

  Note({
    required this.id,
    required this.type,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.isHidden,
  });

  Map<String, dynamic> toMap();

  factory Note.fromFirebase(DocumentSnapshot doc) {
    final typeIndex = doc[db_constant.type] as int;
    final noteType = Type.values[typeIndex];

    if (noteType == Type.text) {
      return TextNote.fromFirebase(doc);
    } else {
      return ToDo.fromFirebase(doc);
    }
  }

  factory Note.newNote({required Type type, required bool isHidden}) {
    if (type == Type.text) {
      return TextNote.newNote(isHidden: isHidden);
    } else {
      return ToDo.newToDo(isHidden: isHidden);
    }
  }
}
