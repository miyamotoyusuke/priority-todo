// component/dialog/edit_repeat_dialog.dart

import 'package:flutter/material.dart';
import '../../model/todo.dart';

class EditRepeatDialog extends StatefulWidget {
  final Todo todo;
  final Function(Todo) onEdit;

  const EditRepeatDialog({Key? key, required this.todo, required this.onEdit})
      : super(key: key);

  @override
  _EditRepeatDialogState createState() => _EditRepeatDialogState();
}

class _EditRepeatDialogState extends State<EditRepeatDialog> {
  late List<String> editedDays;

  @override
  void initState() {
    super.initState();
    editedDays = List.from(widget.todo.days);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '繰り返しを編集: ${widget.todo.title}',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: SingleChildScrollView(
        child: Wrap(
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
            widget.onEdit(Todo(
              widget.todo.id,
              widget.todo.title,
              widget.todo.priority,
              editedDays,
              widget.todo.isCompleted,
            ));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
