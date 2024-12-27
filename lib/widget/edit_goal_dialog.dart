// widget/edit_goal_dialog.dart

import 'package:flutter/material.dart';
import '../model/goal.dart';
import '../util/priority_utils.dart';

class EditGoalDialog extends StatefulWidget {
  final Goal goal;
  final Function(Goal) onEdit;

  const EditGoalDialog({Key? key, required this.goal, required this.onEdit})
      : super(key: key);

  @override
  _EditGoalDialogState createState() => _EditGoalDialogState();
}

class _EditGoalDialogState extends State<EditGoalDialog> {
  late TextEditingController _titleController;
  late int editedPriority;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal.title);
    editedPriority = widget.goal.priority;
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
      title: const Text('長期目標を編集'),
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
              value: editedPriority,
              onChanged: (int? newValue) {
                setState(() {
                  editedPriority = newValue!;
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
          child: const Text('保存'),
          onPressed: () {
            final editedTitle = _titleController.text.trim();
            if (editedTitle.isEmpty || editedTitle.length > 30) {
              setState(() {
                errorMessage = 'タイトルは1文字以上30文字以下にしてください。';
              });
            } else {
              widget.onEdit(Goal(
                widget.goal.id,
                editedTitle,
                editedPriority,
              ));
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
