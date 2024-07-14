import 'package:awesome_notes/models/text_note_model.dart';
import 'package:awesome_notes/models/todo_model.dart';

export 'text_note_model.dart';
export 'todo_model.dart';

enum Type {
  text,
  todo,
}

abstract class Note {
  final String id;
  final Type type;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isHidden;

  Note({
    required this.id,
    required this.type,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.isHidden,
  });

  Map<String, dynamic> toMap();

  String get noteContent;

  factory Note.newNote({required Type type, required bool isHidden}) {
    if (type == Type.text) {
      return TextNote.newNote(isHidden: isHidden);
    } else {
      return ToDo.newToDo(isHidden: isHidden);
    }
  }

  factory Note.fromMap(Map<String, dynamic> map, String id) {
    final type = Type.values[map['type'] as int];
    if (type == Type.text) {
      return TextNote.fromMap(map, id);
    } else {
      return ToDo.fromMap(map, id);
    }
  }

  Note copyWith({
    String? id,
    Type? type,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isHidden,
  });
}
