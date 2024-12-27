// widget/add_goal_dialog.dart

import 'package:flutter/material.dart';
import '../util/priority_utils.dart';

class AddGoalDialog extends StatefulWidget {
  final Function(String, int) onAdd;

  const AddGoalDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddGoalDialogState createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final TextEditingController _titleController = TextEditingController();
  int selectedPriority = 2; // デフォルトは低(2)
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
      title: const Text('新しい長期目標を追加'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              maxLength: 30,
              decoration: InputDecoration(
                hintText: '長期目標のタイトル',
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
            final newTitle = _titleController.text.trim();
            if (newTitle.isEmpty || newTitle.length > 30) {
              setState(() {
                errorMessage = 'タイトルは1文字以上30文字以下にしてください。';
              });
            } else {
              widget.onAdd(newTitle, selectedPriority);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
