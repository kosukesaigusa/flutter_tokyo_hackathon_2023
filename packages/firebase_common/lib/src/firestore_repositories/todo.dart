import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestore_documents/todo.dart';

class TodoRepository {
  final _query = TodoQuery();

  /// 指定した [userId] の [Todo] 一覧を `dueDateTime` の降順で購読する。
  Stream<List<ReadTodo>> subscribeTodos({
    required String userId,
    required bool descending,
  }) =>
      _query.subscribeDocuments(
        queryBuilder: (query) => query
            .where('userId', isEqualTo: userId)
            .orderBy('dueDateTime', descending: descending),
      );

  /// [Todo] を作成する。
  Future<DocumentReference<CreateTodo>> add({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDateTime,
  }) =>
      _query.add(
        createTodo: CreateTodo(
          userId: userId,
          title: title,
          description: description,
          dueDateTime: dueDateTime,
          isDone: false,
        ),
      );

  /// 指定した [Todo] の `isDone` を更新する。
  Future<void> updateCompletionStatus({
    required String todoId,
    required bool value,
  }) =>
      _query.update(todoId: todoId, updateTodo: UpdateTodo(isDone: value));
}
