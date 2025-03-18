import '../importer.dart';

part 'goal_provider.g.dart';

@riverpod
Stream<List<Goal>> goals(GoalsRef ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // ユーザーが認証されていない場合は空のリストを返す
    return Stream.value([]);
  }
  
  final userId = user.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('goals')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Goal.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList()
          ..sort((a, b) => a.priority.compareTo(b.priority)));
}

@riverpod
class GoalNotifier extends _$GoalNotifier {
  @override
  FutureOr<void> build() {
    // Nothing to initialize
  }

  Future<void> addGoal(String title, int priority) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('ユーザーが認証されていません');
    }
    
    final userId = user.uid;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals')
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
    });
  }

  Future<void> updateGoal(Goal goal) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('ユーザーが認証されていません');
    }
    
    final userId = user.uid;
    
    // 入力検証
    if (goal.title.isEmpty) {
      throw Exception('タイトルは必須です');
    }
    
    if (goal.title.length > 30) {
      throw Exception('タイトルは30文字以内にしてください');
    }
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goal.id)
        .update(goal.toMap());
  }

  Future<void> deleteGoal(String goalId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('ユーザーが認証されていません');
    }
    
    final userId = user.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .delete();
  }
}
