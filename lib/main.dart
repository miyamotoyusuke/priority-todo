// main.dart

import 'importer.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// セキュアストレージのインスタンス
const secureStorage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 環境変数の読み込み
  await dotenv.load(fileName: '.env');
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 認証処理
  await initializeAuth();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// 認証の初期化
Future<void> initializeAuth() async {
  try {
    // 既存のユーザーIDを取得
    final userId = await secureStorage.read(key: 'user_id');
    
    if (userId != null) {
      // 既存のユーザーIDがある場合は匿名認証を再利用
      try {
        await FirebaseAuth.instance.signInWithCustomToken(userId);
      } catch (e) {
        // トークンが無効になっている場合は新しい匿名認証を作成
        await createAnonymousUser();
      }
    } else {
      // 新しい匿名ユーザーを作成
      await createAnonymousUser();
    }
  } catch (e) {
    // エラーハンドリング
    print('認証エラー: $e');
    // フォールバックとして匿名認証を使用
    await FirebaseAuth.instance.signInAnonymously();
  }
}

// 匿名ユーザーの作成と保存
Future<void> createAnonymousUser() async {
  final credential = await FirebaseAuth.instance.signInAnonymously();
  final user = credential.user;
  if (user != null) {
    // ユーザーIDをセキュアに保存
    await secureStorage.write(key: 'user_id', value: user.uid);
  }
}
