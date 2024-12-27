// widget/edit_todo_dialog.dart

import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../util/priority_utils.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo todo;
  final Function(Todo) onEdit;

  const EditTodoDialog({Key? key, required this.todo, required this.onEdit})
      : super(key: key);

  @override
  _EditTodoDialogState createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController _titleController;
  late int editedPriority;
  late List<String> editedDays;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    editedPriority = widget.todo.priority;
    editedDays = List.from(widget.todo.days);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<int>> get _priorityItems {
    return [
      DropdownMenuItem(value: 0, child: Text(priorityToString(0))),
      DropdownMenuItem(value: 1, child: Text(priorityToString(1))),
      DropdownMenuItem(value: 2, child: Text(priorityToString(2))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('TODOを編集'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              maxLength: 30,
              decoration: InputDecoration(
                hintText: 'TODOのタイトル',
                errorText: errorMessage,
              ),
            ),
            const SizedBox(height: 16),
            const Text('優先度:'),
            DropdownButton<int>(
              value: editedPriority,
              onChanged: (int? newValue) {
                setState(() {
                  editedPriority = newValue!;
                });
              },
              items: _priorityItems,
            ),
            const SizedBox(height: 16),
            const Text('曜日:'),
            Wrap(
              spacing: 8,
              children: ['月', '火', '水', '木', '金', '土', '日'].map((day) {
                return FilterChip(
                  label: Text(day),
                  selected: editedDays.contains(day),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        editedDays.add(day);
                      } else {
                        editedDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('保存'),
          onPressed: () {
            final editedTitle = _titleController.text.trim();
            if (editedTitle.isEmpty || editedTitle.length > 30) {
              setState(() {
                errorMessage = 'タイトルは1文字以上30文字以下にしてください。';
              });
            } else {
              widget.onEdit(Todo(
                widget.todo.id,
                editedTitle,
                editedPriority,
                editedDays,
                widget.todo.isCompleted,
              ));
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
