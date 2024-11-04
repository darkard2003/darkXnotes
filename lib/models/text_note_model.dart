import 'package:awesome_notes/models/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cloud_database/database_constant.dart' as db_constant;
import 'package:awesome_notes/services/encryption/cypher.dart';

class TextNote extends Note {
  String _content;

  final cypher = Cypher();

  TextNote({
    required super.id,
    required super.type,
    required super.title,
    required String content,
    required super.createdAt,
    required super.updatedAt,
    required super.isHidden,
  })  : _content = content.isNotEmpty ? Cypher().encrypt(content) : "";

  set content(String source) {
    _content = source.isNotEmpty ? cypher.encrypt(source) : "";
  }

  String get content {
    return _content.isNotEmpty ? cypher.decrypt(_content) : "";
  }

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
