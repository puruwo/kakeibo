import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kakeibo/repository/tbl002_record/tbl002_record.dart';
import 'package:kakeibo/repository/tbl001_record/tbl001_record.dart';

part 'tbl002_state.g.dart';

@riverpod
class TBL002RecordNotifier extends _$TBL002RecordNotifier {
  @override
  TBL002Record build() {
    DateTime dt = DateTime.now();
    return TBL002Record(year: dt.year, month: dt.month, day: dt.day);
  }

  //tbl002Recordのメソッドにアクセス
  //stateからアクセスして下記のようにラップする必要がある
  void insert() {
    state.insert();
  }

  void setData(TBL002Record tbl002record) {
    state = tbl002record;
  }

  void update() {
    state.update();
  }

  void updateDateTime(DateTime dt) {
    final oldState = state;
    final newState =
        oldState.copyWith(year: dt.year, month: dt.month, day: dt.day);
    state = newState;
  }

  void updatePrice(int price) {
    final oldState = state;
    final newState = oldState.copyWith(price: price);
    state = newState;
  }

  void updateCategory(int category) {
    final oldState = state;
    final newState = oldState.copyWith(category: category);
    state = newState;
  }

  void updateMemo(String memo) {
    final oldState = state;
    final newState = oldState.copyWith(memo: memo);
    state = newState;
  }

  void delete() {
    state.delete();
  }

  TBL001Record convertTo001() {
    //idは0で設定、お互いの登録済みのレコードに影響を与えないようにするため
    return TBL001Record(
      id: 0,
      category: 0,
      price: state.price,
      memo: state.memo,
      year: state.year,
      month: state.month,
      day: state.day,
    );
  }
}
