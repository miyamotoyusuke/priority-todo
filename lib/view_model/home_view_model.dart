import '../importer.dart';
import '../component/dialog/repeats_list_dialog.dart';
import '../component/dialog/add_todo_dialog.dart';
import '../component/dialog/add_goal_dialog.dart';
import '../component/dialog/edit_todo_dialog.dart';
import '../component/dialog/edit_goal_dialog.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  int build() {
    // Return the current tab index (0 for Todo, 1 for Goals)
    return 0;
  }

  void setTabIndex(int index) {
    state = index;
  }

  // Backup functionality
  void showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'バックアップ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'バックアップ機能はまだ実装されていません。',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '閉じる',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Bug report functionality
  void showReportBugDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'バグを報告',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'バグ報告機能はまだ実装されていません。',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '閉じる',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show repeats list dialog
  void showRepeatsList(BuildContext context, List<Todo> todos) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '繰り返し一覧',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: RepeatsListDialog(
            todos: todos,
            onUpdate: (updatedTodo) {
              ref.read(todoNotifierProvider.notifier).updateTodo(updatedTodo);
            },
          ),
          actions: [
            TextButton(
              child: Text(
                '閉じる',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show add todo dialog
  void showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddTodoDialog(
          onAdd: (title, priority, days) {
            ref.read(todoNotifierProvider.notifier).addTodo(title, priority, days);
          },
        );
      },
    );
  }

  // Show add goal dialog
  void showAddGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddGoalDialog(
          onAdd: (title, priority) {
            ref.read(goalNotifierProvider.notifier).addGoal(title, priority);
          },
        );
      },
    );
  }

  // Edit todo
  void editTodo(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (context) {
        return EditTodoDialog(
          todo: todo,
          onEdit: (editedTodo) {
            ref.read(todoNotifierProvider.notifier).updateTodo(editedTodo);
          },
        );
      },
    );
  }

  // Edit goal
  void editGoal(BuildContext context, Goal goal) {
    showDialog(
      context: context,
      builder: (context) {
        return EditGoalDialog(
          goal: goal,
          onEdit: (editedGoal) {
            ref.read(goalNotifierProvider.notifier).updateGoal(editedGoal);
          },
        );
      },
    );
  }

  // Delete todo
  void deleteTodo(BuildContext context, Todo todo) {
    ConfirmationDialog.show(
      context,
      title: '確認',
      content: 'このTODOを削除しますか？',
      confirmText: '削除',
      onConfirm: () {
        ref.read(todoNotifierProvider.notifier).deleteTodo(todo.id);
      },
    );
  }

  // Delete goal
  void deleteGoal(BuildContext context, Goal goal) {
    ConfirmationDialog.show(
      context,
      title: '確認',
      content: 'この長期目標を削除しますか？',
      confirmText: '削除',
      onConfirm: () {
        ref.read(goalNotifierProvider.notifier).deleteGoal(goal.id);
      },
    );
  }

  // Toggle todo complete
  void toggleTodoComplete(Todo todo) {
    ref.read(todoNotifierProvider.notifier).toggleTodoComplete(todo);
  }
}
