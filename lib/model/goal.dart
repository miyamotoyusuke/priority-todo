// model/goal.dart

class Goal {
  String id;
  String title;
  int priority;

  Goal(this.id, this.title, this.priority);

  // Firebase用のコンストラクタ
  Goal.fromMap(Map<String, dynamic> map, String documentId)
      : id = documentId,
        title = map['title'],
        priority = map['priority'];

  // Firebase用のデータ変換メソッド
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'priority': priority,
    };
  }
}
