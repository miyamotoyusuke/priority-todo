import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../util/priority_utils.dart';

// 曜日の順序を定義
const List<String> dayOrder = ['月', '火', '水', '木', '金', '土', '日'];

// 曜日をソートする関数
List<String> sortDays(List<String> days) {
  return [...days]..sort((a, b) => dayOrder.indexOf(a) - dayOrder.indexOf(b));
}

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(todo.id),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: priorityColor(todo.priority),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            ),
            if (todo.days.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '繰り返し: ${sortDays(todo.days).join(', ')}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
