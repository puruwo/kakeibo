import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tableNameKey.dart';

//Freezedで生成されるデータクラス
part 'tbl004_record.freezed.dart';
//jsonを変換する処理が生成されるクラス
part 'tbl004_record.g.dart';

DatabaseHelper db = DatabaseHelper.instance;

@freezed
class TBL004Record with _$TBL004Record {
  const TBL004Record._();

  const factory TBL004Record({
    required int id,
    required String colorCode,
    required String bigCategoryName,
    required String resourcePath,
    required int displayOrder,
    required int isDisplayed,
  }) = _TBL004Record;

  @override
  factory TBL004Record.fromJson(Map<String, dynamic> json) =>
      _$TBL004RecordFromJson(json);

  //登録ボタン押下関数
  insert() {
    print('id: $id,smallCategoryKey: $colorCode,bigCategoryKey: $bigCategoryName,categoryName: $resourcePath,defaultDisplayed: $displayOrder,を登録しました');
    // //データベースに格納の処理
    print(db.insert(TBL004RecordKey().tableName,{
      TBL004RecordKey().id: id,
      TBL004RecordKey().colorCode: colorCode,
      TBL004RecordKey().bigCategoryName: bigCategoryName,
      TBL004RecordKey().resourcePath: resourcePath,
      TBL004RecordKey().displayOrder: displayOrder,
      TBL004RecordKey().isDisplayed: isDisplayed,
    }));
  }

  update(){
    print('id: $id,smallCategoryKey: $colorCode,bigCategoryKey: $bigCategoryName,categoryName: $resourcePath,defaultDisplayed: $displayOrder,isDisplayed:$isDisplayedを登録しました');
    db.update(TBL004RecordKey().tableName, {
      TBL004RecordKey().id: id,
      TBL004RecordKey().colorCode: colorCode,
      TBL004RecordKey().bigCategoryName: bigCategoryName,
      TBL004RecordKey().resourcePath: resourcePath,
      TBL004RecordKey().displayOrder: displayOrder,
      TBL004RecordKey().isDisplayed: isDisplayed,
    }, id);
  }

  //削除機能はなし
  //過去のレコードのカテゴリーの参照先がなくなってしまうため
}
