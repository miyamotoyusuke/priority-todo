// component/dialog/edit_goal_dialog.dart

import 'package:flutter/material.dart';
import '../../model/goal.dart';
import '../../core/utils/priority_utils.dart';

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
        '長期目標を編集',
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
                hintText: '長期目標のタイトル',
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
