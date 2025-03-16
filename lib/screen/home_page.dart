// screen/home_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/todo.dart';
import '../model/goal.dart';
import '../widget/todo_list.dart';
import '../widget/goal_list.dart';
import '../widget/add_todo_dialog.dart';
import '../widget/add_goal_dialog.dart';
import '../widget/edit_todo_dialog.dart';
import '../widget/edit_goal_dialog.dart';
import '../widget/repeats_list_dialog.dart';
import '../util/priority_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  late String userId;
  late CollectionReference todosCollection;
  late CollectionReference goalsCollection;

  List<Todo> _todos = [];
  List<Goal> _goals = [];

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  void _initializeFirebase() {
    userId = FirebaseAuth.instance.currentUser!.uid;
    todosCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('todos');
    goalsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals');

    _fetchTodos();
    _fetchGoals();
  }

  void _fetchTodos() {
    todosCollection.snapshots().listen((snapshot) {
      setState(() {
        _todos = snapshot.docs.map((doc) {
          return Todo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        _sortTodos();
      });
    });
  }

  void _fetchGoals() {
    goalsCollection.snapshots().listen((snapshot) {
      setState(() {
        _goals = snapshot.docs.map((doc) {
          return Goal.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        _sortGoals();
      });
    });
  }

  void _sortTodos() {
    _todos.sort((a, b) => a.priority.compareTo(b.priority));
  }

  void _sortGoals() {
    _goals.sort((a, b) => a.priority.compareTo(b.priority));
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('バックアップ'),
          content: const Text('バックアップ機能はまだ実装されていません。'),
          actions: <Widget>[
            TextButton(
              child: const Text('閉じる'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showReportBugDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('バグを報告'),
          content: const Text('バグ報告機能はまだ実装されていません。'),
          actions: <Widget>[
            TextButton(
              child: const Text('閉じる'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showRepeatsList() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('繰り返し一覧'),
          content: RepeatsListDialog(
            todos: _todos,
            onUpdate: (updatedTodo) {
              todosCollection.doc(updatedTodo.id).update(updatedTodo.toMap());
            },
          ),
          actions: [
            TextButton(
              child: const Text('閉じる'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddTodoDialog(
          onAdd: (title, priority, days) {
            final docRef = todosCollection.doc();
            docRef.set({
              'title': title,
              'priority': priority,
              'days': days,
              'isCompleted': false,
            });
          },
        );
      },
    );
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddGoalDialog(
          onAdd: (title, priority) {
            final docRef = goalsCollection.doc();
            docRef.set({
              'title': title,
              'priority': priority,
            });
          },
        );
      },
    );
  }

  void _editTodo(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return EditTodoDialog(
          todo: _todos[index],
          onEdit: (editedTodo) {
            todosCollection.doc(editedTodo.id).update(editedTodo.toMap());
          },
        );
      },
    );
  }

  void _editGoal(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return EditGoalDialog(
          goal: _goals[index],
          onEdit: (editedGoal) {
            goalsCollection.doc(editedGoal.id).update(editedGoal.toMap());
          },
        );
      },
    );
  }

  void _deleteTodo(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('このTODOを削除しますか？'),
          actions: [
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('削除'),
              onPressed: () {
                todosCollection.doc(_todos[index].id).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteGoal(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('この長期目標を削除しますか？'),
          actions: [
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('削除'),
              onPressed: () {
                goalsCollection.doc(_goals[index].id).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleTodoComplete(int index) {
    final todo = _todos[index];
    todosCollection.doc(todo.id).update({
      'isCompleted': !todo.isCompleted,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('優先度TODO'),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.repeat),
              onPressed: _showRepeatsList,
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (value) {
              switch (value) {
                case 'backup':
                  _showBackupDialog();
                  break;
                case 'report':
                  _showReportBugDialog();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'backup',
                child: ListTile(
                  leading: Icon(Icons.backup),
                  title: Text('バックアップ'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'report',
                child: ListTile(
                  leading: Icon(Icons.bug_report),
                  title: Text('バグを報告'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _currentIndex == 0 ? 'TODO リスト' : '長期目標',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              children: [
                TodoList(
                  todos: _todos,
                  onToggleComplete: _toggleTodoComplete,
                  onEdit: _editTodo,
                  onDelete: _deleteTodo,
                ),
                GoalList(
                  goals: _goals,
                  onEdit: _editGoal,
                  onDelete: _deleteGoal,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentIndex == 0) {
            _showAddTodoDialog();
          } else {
            _showAddGoalDialog();
          }
        },
        child: const Icon(Icons.add),
        tooltip: _currentIndex == 0 ? 'TODOを追加' : '長期目標を追加',
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Todo'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
        ],
      ),
    );
  }
}
