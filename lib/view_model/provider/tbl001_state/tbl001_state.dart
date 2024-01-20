import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kakeibo/repository/tbl001_record.dart';

part 'tbl001_state.g.dart';

@riverpod
class TBL001RecordNotifier extends _$TBL001RecordNotifier {
  @override
  TBL001Record build() {
    DateTime dt = DateTime.now();
    return TBL001Record(year: dt.year, month: dt.month, day: dt.day);
  }

  //tbl001Recordのメソッドにアクセス
  //stateからアクセスして下記のようにラップする必要がある
  void insertToTable(){
    state.insert();
  }

  void updateDateTime(DateTime dt) {
    final oldState = state;
    final newState = oldState.copyWith(
      year: dt.year,
      month: dt.month,
      day: dt.day
    );
    state = newState;
  }

  void updatePrice(int price) {
    final oldState = state;
    final newState = oldState.copyWith(
      price: price
    );
    state = newState;
  }

  void updateCategory(int category) {
    final oldState = state;
    final newState = oldState.copyWith(
      category: category
    );
    state = newState;
  }

  void updateMemo(String memo) {
    final oldState = state;
    final newState = oldState.copyWith(
      memo: memo
    );
    state = newState;
  }
}
