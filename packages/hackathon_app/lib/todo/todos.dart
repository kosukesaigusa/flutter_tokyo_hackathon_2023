import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';
import 'ui/todos.dart';

final todosOrderByStateProvider = StateProvider.autoDispose<TodosOrderBy>(
  (ref) => TodosOrderBy.dueDateTimeDesc,
);

/// 指定した `userId` の [Todo] 一覧を購読する [StreamProvider].
final todosStreamProvider =
    StreamProvider.family.autoDispose<List<ReadTodo>, String>((ref, userId) {
  final repository = ref.watch(todoRepositoryProvider);
  return repository.subscribeTodos(
    userId: userId,
    descending:
        ref.watch(todosOrderByStateProvider) == TodosOrderBy.dueDateTimeDesc,
  );
});

final todoServiceProvider = Provider.autoDispose<TodoService>(
  (ref) => TodoService(todoRepository: ref.watch(todoRepositoryProvider)),
);

class TodoService {
  const TodoService({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  final TodoRepository _todoRepository;

  /// [Todo] を作成する。
  Future<void> create({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDateTime,
  }) =>
      _todoRepository.add(
        userId: userId,
        title: title,
        description: description,
        dueDateTime: dueDateTime,
      );

  /// 指定した [Todo] の `isDone` を更新する。
  Future<void> updateCompletionStatus({
    required String todoId,
    required bool value,
  }) =>
      _todoRepository.updateCompletionStatus(
        todoId: todoId,
        value: value,
      );
}
