import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tableNameKey.dart';

//Freezedで生成されるデータクラス
part 'tbl003_record.freezed.dart';
//jsonを変換する処理が生成されるクラス
part 'tbl003_record.g.dart';

DatabaseHelper db = DatabaseHelper.instance;

@freezed
class TBL003Record with _$TBL003Record {
  const TBL003Record._();

  const factory TBL003Record({
    required int id,
    required int smallCategoryKey,
    required int bigCategoryKey,
    required String categoryName,
    required int defaultDisplayed,
  }) = _TBL003Record;

  @override
  factory TBL003Record.fromJson(Map<String, dynamic> json) =>
      _$TBL003RecordFromJson(json);

  //登録ボタン押下関数
  insert() {
    print('id: $id,smallCategoryKey: $smallCategoryKey,bigCategoryKey: $bigCategoryKey,categoryName: $categoryName,defaultDisplayed: $defaultDisplayed,を登録しました');
    // //データベースに格納の処理
    print(db.insert(TBL003RecordKey().tableName,{
      TBL003RecordKey().id: id,
      TBL003RecordKey().smallCategoryKey: smallCategoryKey,
      TBL003RecordKey().bigCategoryKey: bigCategoryKey,
      TBL003RecordKey().categoryName: categoryName,
      TBL003RecordKey().defaultDisplayed: defaultDisplayed,
    }));
  }

  update(){
    print('id: $id,smallCategoryKey: $smallCategoryKey,bigCategoryKey: $bigCategoryKey,categoryName: $categoryName,defaultDisplayed: $defaultDisplayed,にこうしんしました');
    db.update(TBL003RecordKey().tableName, {
      TBL003RecordKey().id: id,
      TBL003RecordKey().smallCategoryKey: smallCategoryKey,
      TBL003RecordKey().bigCategoryKey: bigCategoryKey,
      TBL003RecordKey().categoryName: categoryName,
      TBL003RecordKey().defaultDisplayed: defaultDisplayed,
    }, id);
  }

  //削除機能はなし
  //過去のレコードのカテゴリーの参照先がなくなってしまうため
}
