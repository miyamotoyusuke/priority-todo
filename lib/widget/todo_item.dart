// widget/todo_item.dart

import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../util/priority_utils.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoItem({
    Key? key,
    required this.todo,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(todo.id),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: priorityColor(todo.priority)),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(todo.days.isNotEmpty ? '繰り返し: ${todo.days.join(', ')}' : ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
            Checkbox(
              value: todo.isCompleted,
              onChanged: (bool? value) {
                onToggleComplete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
