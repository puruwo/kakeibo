import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kakeibo/repository/tbl001_record/tbl001_record.dart';
import 'package:kakeibo/repository/tbl002_record/tbl002_record.dart';
import 'package:kakeibo/repository/torok_record/torok_record.dart';

part 'torok_state.g.dart';

@riverpod
class TorokRecordNotifier extends _$TorokRecordNotifier {
  @override
  TorokRecord build() {
    DateTime dt = DateTime.now();
    String date = DateFormat('yyyyMMdd').format(dt);
    return TorokRecord(date:date);
  }

  void setData(TorokRecord torokRecord) {
    state = torokRecord;
  }

  void updateDate(DateTime dt) {
    String date = DateFormat('yyyyMMdd').format(dt);
    final oldState = state;
    final newState =
        oldState.copyWith(date:date);
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
  
  TBL001Record setToTBL001() {
    return TBL001Record(
      id: state.id,
      category: state.category,
      price: state.price,
      memo: state.memo,
      date: state.date,
    );
  }

  TBL002Record setToTBL002() {
    return TBL002Record(
      id: state.id,
      category: state.category,
      price: state.price,
      memo: state.memo,
      date: state.date,
    );
  }
}
