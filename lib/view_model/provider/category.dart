import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'category.g.dart';

@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  @override
  int build() {
    // 最初のデータ
    return 1;
  }
  
  void updateState(int num) {
    // データを上書き
    state = num;
  }
}