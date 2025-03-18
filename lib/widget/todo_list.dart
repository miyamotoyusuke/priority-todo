import 'package:flutter/material.dart';
import '../model/todo.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final Function(int) onToggleComplete;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const TodoList({
    Key? key,
    required this.todos,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedTodos = todos.where((todo) => todo.isCompleted).toList();
    final incompleteTodos = todos.where((todo) => !todo.isCompleted).toList();

    Widget buildTodoItem(Todo todo, int index) {
      return GestureDetector(
        onTap: () => onEdit(index),
        child: Dismissible(
          key: ValueKey(todo.id),
          background: _buildSwipeBackground(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            icon: Icons.check,
          ),
          secondaryBackground: _buildSwipeBackground(
            color: Colors.red,
            alignment: Alignment.centerRight,
            icon: Icons.delete,
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              // 右スワイプ（完了）を許可
              onToggleComplete(index);
              return true;
            } else if (direction == DismissDirection.endToStart) {
              // 左スワイプ（削除）で確認ダイアログを表示
              final confirmDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('タスクを削除'),
                    content: const Text('このタスクを削除してもよろしいですか？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('削除'),
                      ),
                    ],
                  );
                },
              );
              if (confirmDelete == true) {
                onDelete(index);
                return true;
              }
              return false;
            }
            return false;
          },
          child: TodoItem(
            key: ValueKey(todo.id),
            todo: todo
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Text(
          '未完了', 
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...incompleteTodos.map((todo) {
          final index = todos.indexOf(todo);
          return buildTodoItem(todo, index);
        }).toList(),
        const SizedBox(height: 8),
        const Divider(height: 50),
        Text(
          '完了', 
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...completedTodos.map((todo) {
          final index = todos.indexOf(todo);
          return buildTodoItem(todo, index);
        }).toList(),
      ],
    );
  }
  Widget _buildSwipeBackground({
    required Color color,
    required Alignment alignment,
    required IconData icon,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8), // 背景に角丸を適用
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
