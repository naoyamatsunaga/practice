import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/database.dart';

/// データベースインスタンスを提供するProvider
/// アプリ全体で同じデータベースインスタンスを使用するために使用します
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProviderはmain.dartで上書きする必要があります');
});
