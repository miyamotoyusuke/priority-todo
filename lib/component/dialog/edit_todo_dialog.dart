// component/dialog/edit_todo_dialog.dart

import 'package:flutter/material.dart';
import '../../model/todo.dart';
import '../../core/utils/priority_utils.dart';

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
      DropdownMenuItem(
        value: 0, 
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: priorityColor(0),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              priorityToString(0),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      DropdownMenuItem(
        value: 1, 
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: priorityColor(1),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              priorityToString(1),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      DropdownMenuItem(
        value: 2, 
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: priorityColor(2),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              priorityToString(2),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'TODOを編集',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              maxLength: 30,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'TODOのタイトル',
                errorText: errorMessage,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '優先度:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
            Text(
              '曜日:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(
              spacing: 8,
              children: ['月', '火', '水', '木', '金', '土', '日'].map((day) {
                return FilterChip(
                  label: Text(
                    day,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
          child: Text(
            'キャンセル',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            '保存',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
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
