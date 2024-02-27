import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tableNameKey.dart';

//Freezedで生成されるデータクラス
part 'torok_record.freezed.dart';
//jsonを変換する処理が生成されるクラス
part 'torok_record.g.dart';

DatabaseHelper db = DatabaseHelper.instance;

@freezed
class TorokRecord with _$TorokRecord {
  const TorokRecord._();

  const factory TorokRecord({
    @Default(0) int id,
    required String date,
    @Default(0) int price,
    @Default(0) int category,
    @Default('') String memo,
  }) = _TorokRecord;

  @override
  factory TorokRecord.fromJson(Map<String, dynamic> json) =>
      _$TorokRecordFromJson(json);

  update() {
    print('$category,$date,$price,$memo,にこうしんしました');
    db.update(
        TBL001RecordKey().tableName,
        {
          TBL001RecordKey().date: date,
          TBL001RecordKey().price: price,
          TBL001RecordKey().paymentCategoryId: category,
          TBL001RecordKey().memo: memo
        },
        id);
  }
}
