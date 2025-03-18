// widget/repeats_list_dialog.dart

import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../util/priority_utils.dart';
import 'edit_repeat_dialog.dart';

// 曜日の順序を定義
const List<String> dayOrder = ['月', '火', '水', '木', '金', '土', '日'];

// 曜日をソートする関数
List<String> sortDays(List<String> days) {
  return [...days]..sort((a, b) => dayOrder.indexOf(a) - dayOrder.indexOf(b));
}

class RepeatsListDialog extends StatelessWidget {
  final List<Todo> todos;
  final Function(Todo) onUpdate;

  const RepeatsListDialog({Key? key, required this.todos, required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repeatingTodos = todos.where((todo) => todo.days.isNotEmpty).toList();

    if (repeatingTodos.isEmpty) {
      return const Text('繰り返しタスクはありません。');
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: repeatingTodos.map((todo) {
          return ListTile(
            leading: CircleAvatar(backgroundColor: priorityColor(todo.priority)),
            title: Text(todo.title),
            subtitle: Text('繰り返し: ${sortDays(todo.days).join(', ')}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return EditRepeatDialog(
                      todo: todo,
                      onEdit: (editedTodo) {
                        onUpdate(editedTodo);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
