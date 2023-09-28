import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_ui_feedback_controller.dart';
import '../todos.dart';

final todosControllerProvider = Provider.autoDispose<TodosController>(
  (ref) => TodosController(
    todoService: ref.watch(todoServiceProvider),
    appUIFeedbackController: ref.watch(appUIFeedbackControllerProvider),
  ),
);

class TodosController {
  const TodosController({
    required TodoService todoService,
    required AppUIFeedbackController appUIFeedbackController,
  })  : _todoService = todoService,
        _appUIFeedbackController = appUIFeedbackController;

  final TodoService _todoService;

  final AppUIFeedbackController _appUIFeedbackController;

  /// [Todo] を追加する。
  Future<void> createTodo({
    required String userId,
    required String title,
    required String description,
    required DateTime? dueDateTime,
  }) async {
    if (title.isEmpty || description.isEmpty || dueDateTime == null) {
      _appUIFeedbackController.showSnackBar('入力内容を確認してください');
      return;
    }
    await _todoService.create(
      userId: userId,
      title: title,
      description: description,
      dueDateTime: dueDateTime,
    );
  }

  /// 指定した [Todo] の `isDone` をトグルする。
  Future<void> toggleCompletionStatus({
    required String todoId,
    required bool isDone,
  }) =>
      _todoService.updateCompletionStatus(todoId: todoId, value: isDone);
}
