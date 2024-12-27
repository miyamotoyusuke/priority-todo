// util/utils.dart

import 'package:flutter/material.dart';

// 優先度に応じた色を返す関数
Color priorityColor(int priority) {
  switch (priority) {
    case 0:
      return Colors.red;
    case 1:
      return Colors.orange;
    case 2:
      return Colors.grey;
    default:
      return Colors.grey;
  }
}

// 優先度を文字列に変換する関数
String priorityToString(int priority) {
  switch (priority) {
    case 0:
      return '高';
    case 1:
      return '中';
    case 2:
      return '低';
    default:
      return '不明';
  }
}
