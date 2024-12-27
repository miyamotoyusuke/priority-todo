// model/todo.dart

class Todo {
  String id;
  String title;
  int priority;
  List<String> days;
  bool isCompleted;

  Todo(this.id, this.title, this.priority, this.days, this.isCompleted);

  // Firebase用のコンストラクタ
  Todo.fromMap(Map<String, dynamic> map, String documentId)
      : id = documentId,
        title = map['title'],
        priority = map['priority'],
        days = List<String>.from(map['days']),
        isCompleted = map['isCompleted'];

  // Firebase用のデータ変換メソッド
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'priority': priority,
      'days': days,
      'isCompleted': isCompleted,
    };
  }
}
