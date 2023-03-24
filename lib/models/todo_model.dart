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
}

class ToDo extends Note {
  List<ToDoItem> toDoItems;
  List<ToDoItem> completedToDoItems;

  ToDo({
    required String id,
    required Type type,
    required String title,
    required this.toDoItems,
    required this.completedToDoItems,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isHidden,
  }) : super(
          id: id,
          type: type,
          title: title,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isHidden: isHidden,
        );

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

  factory ToDo.fromFirebase(DocumentSnapshot doc) {
    return ToDo(
      id: doc.id,
      type: Type.values[doc[db_constant.type] as int],
      title: doc[db_constant.title] as String,
      toDoItems: (doc[db_constant.toDoItems] as List<dynamic>)
          .map((item) => ToDoItem.fromMap(item as Map<String, Object>))
          .toList(),
      completedToDoItems: (doc[db_constant.complitedToDoItems] as List<dynamic>)
          .map((item) => ToDoItem.fromMap(item as Map<String, Object>))
          .toList(),
      createdAt: doc[db_constant.createdAt] as DateTime,
      updatedAt: doc[db_constant.updatedAt] as DateTime,
      isHidden: doc[db_constant.isHidden] as bool,
    );
  }
}
