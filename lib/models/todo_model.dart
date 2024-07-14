import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cloud_database/database_constant.dart' as db_constant;
import 'note_model.dart';

class ToDoItem {
  String title;
  bool completed;
  DateTime createdAt;
  DateTime updatedAt;
  String id;

  ToDoItem({
    required this.title,
    required this.completed,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ToDoItem.newToDoItem() {
    return ToDoItem(
      id: '',
      title: '',
      completed: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<dynamic, Object> toMap() {
    return {
      db_constant.id: id,
      db_constant.title: title,
      db_constant.complited: completed,
      db_constant.createdAt: createdAt,
      db_constant.updatedAt: updatedAt,
    };
  }

  factory ToDoItem.fromMap(Map<String, Object> map) {
    return ToDoItem(
      id: map[db_constant.id] as String,
      title: map[db_constant.title] as String,
      completed: map[db_constant.complited] as bool,
      createdAt: map[db_constant.createdAt] as DateTime,
      updatedAt: map[db_constant.updatedAt] as DateTime,
    );
  }

  @override
  String toString() {
    return "[${completed ? 'X' : ' '}] $title";
  }
}

class ToDo extends Note {
  List<ToDoItem> toDoItems;
  List<ToDoItem> completedToDoItems;

  ToDo({
    required super.id,
    required super.type,
    required super.title,
    required this.toDoItems,
    required this.completedToDoItems,
    required super.createdAt,
    required super.updatedAt,
    required super.isHidden,
  });

  factory ToDo.newToDo({required bool isHidden}) {
    return ToDo(
      id: '',
      type: Type.todo,
      title: '',
      toDoItems: [],
      completedToDoItems: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isHidden: isHidden,
    );
  }

  @override
  Map<String, Object> toMap() {
    return {
      db_constant.id: id,
      db_constant.type: type.index,
      db_constant.title: title,
      db_constant.createdAt: createdAt,
      db_constant.updatedAt: updatedAt,
      db_constant.isHidden: isHidden,
      db_constant.toDoItems: toDoItems.map((item) => item.toMap()).toList(),
      db_constant.complitedToDoItems:
          completedToDoItems.map((item) => item.toMap()).toList(),
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map, String id) {
    return ToDo(
      id: id,
      type: Type.values[map[db_constant.type] as int],
      title: map[db_constant.title] as String,
      toDoItems: (map[db_constant.toDoItems] as List<Object>)
          .map((item) => ToDoItem.fromMap(item as Map<String, Object>))
          .toList(),
      completedToDoItems: (map[db_constant.complitedToDoItems] as List<Object>)
          .map((item) => ToDoItem.fromMap(item as Map<String, Object>))
          .toList(),
      createdAt: (map[db_constant.createdAt] as Timestamp).toDate(),
      updatedAt: (map[db_constant.updatedAt] as Timestamp).toDate(),
      isHidden: map[db_constant.isHidden] as bool,
    );
  }

  @override
  String get noteContent {
    return toDoItems.map((item) => item.toString()).join('\n');
  }

  @override
  ToDo copyWith({
    String? id,
    Type? type,
    String? title,
    List<ToDoItem>? toDoItems,
    List<ToDoItem>? completedToDoItems,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isHidden,
  }) {
    return ToDo(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      toDoItems: toDoItems ?? this.toDoItems,
      completedToDoItems: completedToDoItems ?? this.completedToDoItems,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}
