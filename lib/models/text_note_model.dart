import 'package:awesome_notes/models/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cloud_database/database_constant.dart' as db_constant;

class TextNote extends Note {
  String content;

  TextNote({
    required super.id,
    required super.type,
    required super.title,
    required this.content,
    required super.createdAt,
    required super.updatedAt,
    required super.isHidden,
  });

  factory TextNote.fromFirebase(DocumentSnapshot doc) {
    return TextNote(
      id: doc.id,
      type: Type.values[doc[db_constant.type] as int],
      title: doc[db_constant.title] as String,
      content: doc[db_constant.content] as String,
      createdAt: (doc[db_constant.createdAt] as Timestamp).toDate(),
      updatedAt: (doc[db_constant.updatedAt] as Timestamp).toDate(),
      isHidden: doc[db_constant.isHidden] as bool,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      db_constant.title: title,
      db_constant.type: type.index,
      db_constant.content: content,
      db_constant.createdAt: createdAt,
      db_constant.updatedAt: updatedAt,
      db_constant.isHidden: isHidden,
    };
  }

  factory TextNote.newNote({bool isHidden = false}) {
    return TextNote(
      id: '',
      type: Type.text,
      title: '',
      content: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isHidden: isHidden,
    );
  }
}
