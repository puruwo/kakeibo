import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'small_category_edit_mode.g.dart';


@riverpod
class SmallCategoryEditModeNotifier extends _$SmallCategoryEditModeNotifier {
  @override
  bool build() {
    // 最初のデータ
    const now = false;
    return now;
  }

  void updateState() {
    // データを上書き
    state = !state;
  }  
}