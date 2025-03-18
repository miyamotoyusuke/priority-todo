import 'importer.dart';
import 'view/home/home_page.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'タスクマネージャー',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
