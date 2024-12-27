// widget/add_todo_dialog.dart

import 'package:flutter/material.dart';
import '../util/priority_utils.dart';

class AddTodoDialog extends StatefulWidget {
  final Function(String, int, List<String>) onAdd;

  const AddTodoDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController _titleController = TextEditingController();
  int selectedPriority = 2; // デフォルトは低(2)
  final List<String> selectedDays = [];
  String? errorMessage;

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
      title: const Text('新しいTODOを追加'),
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
              value: selectedPriority,
              onChanged: (int? newValue) {
                setState(() {
                  selectedPriority = newValue!;
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
                  selected: selectedDays.contains(day),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedDays.add(day);
                      } else {
                        selectedDays.remove(day);
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
          child: const Text('追加'),
          onPressed: () {
            final newTitle = _titleController.text;
            if (newTitle.length < 1 || newTitle.length > 30) {
              setState(() {
                errorMessage = 'タイトルは1文字以上30文字以下にしてください。';
              });
            } else {
              widget.onAdd(newTitle, selectedPriority, selectedDays);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
