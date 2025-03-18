// widget/goal_list.dart

import 'package:flutter/material.dart';
import '../model/goal.dart';
import 'goal_item.dart';

class GoalList extends StatelessWidget {
  final List<Goal> goals;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const GoalList({
    Key? key,
    required this.goals,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return GoalItem(
          key: ValueKey(goals[index].id),
          goal: goals[index],
          onEdit: () => onEdit(index),
          onDelete: () => onDelete(index),
        );
      },
    );
  }
}
