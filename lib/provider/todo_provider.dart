import '../importer.dart';

part 'todo_provider.g.dart';

@riverpod
Stream<List<Todo>> todos(TodosRef ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // ユーザーが認証されていない場合は空のリストを返す
    return Stream.value([]);
  }
  
  final userId = user.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('todos')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Todo.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList()
          ..sort((a, b) => a.priority.compareTo(b.priority)));
}

@riverpod
class TodoNotifier extends _$TodoNotifier {
  @override
  FutureOr<void> build() {
    // Nothing to initialize
  }

  Future<void> addTodo(String title, int priority, List<String> days) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('ユーザーが認証されていません');
    }
    
    final userId = user.uid;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc();
    
    // 入力検証
    if (title.isEmpty) {
      throw Exception('タイトルは必須です');
    }
    
    if (title.length > 30) {
      throw Exception('タイトルは30文字以内にしてください');
    }
    
    await docRef.set({
      'title': title,
      'priority': priority,
      'days': days,
      'isCompleted': false,
    });
  }

  Future<void> updateTodo(Todo todo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('ユーザーが認証されていません');
    }
    
    final userId = user.uid;
    
    // 入力検証
    if (todo.title.isEmpty) {
      throw Exception('タイトルは必須です');
    }
    
    if (todo.title.length > 30) {
      throw Exception('タイトルは30文字以内にしてください');
    }
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todo.id)
        .update(todo.toMap());
  }

  Future<void> deleteTodo(String todoId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('ユーザーが認証されていません');
    }
    
    final userId = user.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todoId)
        .delete();
  }

  Future<void> toggleTodoComplete(Todo todo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('ユーザーが認証されていません');
    }
    
    final userId = user.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todo.id)
        .update({
      'isCompleted': !todo.isCompleted,
    });
  }
}
