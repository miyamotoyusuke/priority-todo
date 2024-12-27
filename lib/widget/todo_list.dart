// widget/todo_list.dart

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

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        const Text('未完了のタスク', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Container(padding: const EdgeInsets.symmetric(vertical: 8.0)),
        ...incompleteTodos.map((todo) {
          final index = todos.indexOf(todo);
          return TodoItem(
            key: ValueKey(todo.id),
            todo: todo,
            onToggleComplete: () => onToggleComplete(index),
            onEdit: () => onEdit(index),
            onDelete: () => onDelete(index),
          );
        }).toList(),
        const SizedBox(height: 8),
        const Divider(
          height: 50,
        ),
        const Text('完了したタスク', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Container(padding: const EdgeInsets.symmetric(vertical: 8.0)),
        ...completedTodos.map((todo) {
          final index = todos.indexOf(todo);
          return TodoItem(
            key: ValueKey(todo.id),
            todo: todo,
            onToggleComplete: () => onToggleComplete(index),
            onEdit: () => onEdit(index),
            onDelete: () => onDelete(index),
          );
        }).toList(),
      ],
    );
  }
}
