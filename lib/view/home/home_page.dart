import '../../importer.dart';
import '../../component/todo/todo_list.dart';
import '../../component/goal/goal_list.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(homeViewModelProvider);
    final todosAsyncValue = ref.watch(todosProvider);
    final goalsAsyncValue = ref.watch(goalsProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.repeat),
              onPressed: () => todosAsyncValue.whenData((todos) {
                homeViewModel.showRepeatsList(context, todos);
              }),
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (value) {
              switch (value) {
                case 'backup':
                  homeViewModel.showBackupDialog(context);
                  break;
                case 'report':
                  homeViewModel.showReportBugDialog(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'backup',
                child: ListTile(
                  leading: const Icon(Icons.backup),
                  title: Text(
                    'バックアップ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'report',
                child: ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: Text(
                    'バグを報告',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
              currentIndex == 0 ? 'TODO リスト' : '長期目標',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                homeViewModel.setTabIndex(index);
              },
              children: [
                todosAsyncValue.when(
                  data: (todos) => TodoList(
                    todos: todos,
                    onToggleComplete: (index) => homeViewModel.toggleTodoComplete(todos[index]),
                    onEdit: (index) => homeViewModel.editTodo(context, todos[index]),
                    onDelete: (index) => homeViewModel.deleteTodo(context, todos[index]),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      'エラーが発生しました: $error',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                goalsAsyncValue.when(
                  data: (goals) => GoalList(
                    goals: goals,
                    onEdit: (index) => homeViewModel.editGoal(context, goals[index]),
                    onDelete: (index) => homeViewModel.deleteGoal(context, goals[index]),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      'エラーが発生しました: $error',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentIndex == 0) {
            homeViewModel.showAddTodoDialog(context);
          } else {
            homeViewModel.showAddGoalDialog(context);
          }
        },
        child: const Icon(Icons.add),
        tooltip: currentIndex == 0 ? 'TODOを追加' : '長期目標を追加',
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: (index) {
          homeViewModel.setTabIndex(index);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Todo'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
        ],
      ),
    );
  }
}
