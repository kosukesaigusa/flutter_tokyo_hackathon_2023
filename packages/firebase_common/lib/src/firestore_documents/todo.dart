import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'todo.flutterfire_gen.dart';

@FirestoreDocument(path: 'todos', documentName: 'todo')
class Todo {
  const Todo({
    required this.userId,
    required this.title,
    required this.description,
    required this.isDone,
    required this.dueDateTime,
    this.updatedAt,
  });

  final String userId;

  @ReadDefault('')
  final String title;

  @ReadDefault('')
  final String description;

  @ReadDefault(false)
  final bool isDone;

  final DateTime dueDateTime;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? updatedAt;
}
