import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kakeibo/repository/tbl001_record/tbl001_record.dart';
import 'package:kakeibo/repository/tbl002_record/tbl002_record.dart';
import 'package:kakeibo/repository/torok_record/torok_record.dart';

part 'torok_state.g.dart';

// class TorokRecord {
//   const TorokRecord(
//       {this.id = 0,
//       this.price = 0,
//       this.category = 1,
//       this.memo = '',
//       required this.year,
//       required this.month,
//       required this.day});
//   final int id;
//   final int year;
//   final int month;
//   final int day;
//   final int price;
//   final int category;
//   final String memo;
// }

@riverpod
class TorokRecordNotifier extends _$TorokRecordNotifier {
  @override
  TorokRecord build() {
    DateTime dt = DateTime.now();
    return TorokRecord(year: dt.year, month: dt.month, day: dt.day);
  }

  void setData(TorokRecord torokRecord) {
    state = torokRecord;
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
  
  TBL001Record setToTBL001() {
    return TBL001Record(
      id: state.id,
      category: state.category,
      price: state.price,
      memo: state.memo,
      year: state.year,
      month: state.month,
      day: state.day,
    );
  }

  TBL002Record setToTBL002() {
    return TBL002Record(
      id: state.id,
      category: state.category,
      price: state.price,
      memo: state.memo,
      year: state.year,
      month: state.month,
      day: state.day,
    );
  }
}
