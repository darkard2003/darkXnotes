import 'package:awesome_notes/models/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../services/cloud_database/database_constant.dart' as db_constant;

class TextNote extends Note with EquatableMixin {
  final String content;

  TextNote({
    required super.id,
    required super.type,
    required super.title,
    required this.content,
    required super.createdAt,
    required super.updatedAt,
    required super.isHidden,
  });

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
    final id = const Uuid().v4();
    return TextNote(
      id: id,
      type: Type.text,
      title: '',
      content: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isHidden: isHidden,
    );
  }

  @override
  String get noteContent => content;

  factory TextNote.fromMap(Map<String, dynamic> map, String id) {
    return TextNote(
      id: id,
      type: Type.text,
      title: map[db_constant.title] as String,
      content: map[db_constant.content] as String,
      createdAt: (map[db_constant.createdAt] as Timestamp).toDate(),
      updatedAt: (map[db_constant.updatedAt] as Timestamp).toDate(),
      isHidden: map[db_constant.isHidden] as bool,
    );
  }

  @override
  Note copyWith({
    String? id,
    Type? type,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isHidden,
  }) {
    return TextNote(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isHidden: isHidden ?? this.isHidden,
    );
  }

  @override
  List<Object?> get props =>
      [id, type, title, content, createdAt, updatedAt, isHidden];
}
