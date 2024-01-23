import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tableNameKey.dart';

//一周期の日付情報
class TBL001Impl {
  //DatabaseHelperの初期化
  DatabaseHelper db = DatabaseHelper.instance;

  //月またぎ、1月分取得(Mutable)
  Future<List<Map<String, dynamic>>> queryCrossMonthMutableRows(
      DateTime fromDate,DateTime toDate) async {
    //where句の作成
    //一周期の条件指定が難しいのでここで作成
    //ex)
    //from 2023-06-25 to 2023-07-24なら
    //(year = 2023 and month = 6 and day >= 25 and day <= 31) or (year = 2023 and month = 7 and day >= 1 and day <25)
    final where =
        '(${DatabaseHelper.columnYear} = ? and ${DatabaseHelper.columnMonth} = ? and  ${DatabaseHelper.columnDay} >= ? and ${DatabaseHelper.columnDay} <= ?) or (${DatabaseHelper.columnYear} = ? and ${DatabaseHelper.columnMonth} = ?  and ${DatabaseHelper.columnDay} >= ? and ${DatabaseHelper.columnDay} < ?)';
    final whereArgs = [
      fromDate.year,
      fromDate.month,
      fromDate.day,
      DateTime(fromDate.year,fromDate.month+1,0).day,//fromDateの最終日
      toDate.year,
      toDate.month,
      1,
      toDate.day
    ];

    final immutable = db.queryRowsWhere(where, whereArgs);
    final mutable = makeMutable(immutable);

    final addedDateInformationMap = addDateTimeLabelToMap(mutable);

    //tbl001_recordのカラム(_id,year,month,day,price,category,memo)に加えて
    //'stringDate' もある
    return addedDateInformationMap;
  }

  // //1月分取得(Mutable)
  // Future<List<Map<String, dynamic>>> queryMonthMutableRows(
  //     DateTime date) async {
  //   final termDate = TermDate(date);
  //   //where句の作成
  //   //一周期の条件指定が難しいのでここで作成
  //   //ex)
  //   //from 2023-06-25 to 2023-07-24なら
  //   //(year = 2023 and month = 6 and day >= 25 and day <= 31) or (year = 2023 and month = 7 and day >= 1 and day <25)
  //   final where =
  //       '(${DatabaseHelper.columnYear} = ? and ${DatabaseHelper.columnMonth} = ? and  ${DatabaseHelper.columnDay} >= ? and ${DatabaseHelper.columnDay} <= ?) or (${DatabaseHelper.columnYear} = ? and ${DatabaseHelper.columnMonth} = ?  and ${DatabaseHelper.columnDay} >= ? and ${DatabaseHelper.columnDay} < ?)';
  //   final whereArgs = [
  //     termDate.referenceDay!.year,
  //     termDate.referenceDay!.month,
  //     termDate.referenceDay!.day,
  //     termDate.lastDayOfStartMonth,
  //     termDate.dayOfNextPeriod!.year,
  //     termDate.dayOfNextPeriod!.month,
  //     1,
  //     termDate.dayOfNextPeriod!.day
  //   ];

  //   final immutable = db.queryRowsWhere(where, whereArgs);
  //   final mutable = makeMutable(immutable);

  //   final addedDateInformationMap = addDateLabelToMap(mutable);

  //   //tbl001_recordのカラム(_id,year,month,day,price,category,memo)に加えて
  //   //'stringDate' もある
  //   return addedDateInformationMap;
  // }

  //1日分取得(Mutable)
  Future<List<Map<String, dynamic>>> queryDayMutableRows(
      DateTime date) async {
    //where句の作成
    //一周期の条件指定が難しいのでここで作成
    //ex)
    //from 2023-06-25 to 2023-07-24なら
    //(year = 2023 and month = 6 and day >= 25 and day <= 31) or (year = 2023 and month = 7 and day >= 1 and day <25)
    final where =
        '(${DatabaseHelper.columnYear} = ? and ${DatabaseHelper.columnMonth} = ? and  ${DatabaseHelper.columnDay} = ? )';
    final whereArgs = [
      date.year,date.month,date.day
    ];

    final immutable = db.queryRowsWhere(where, whereArgs);
    final mutable = makeMutable(immutable);

    return mutable;
  }

  //全データ取得
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return db.queryRows();
  }
}

Future<List<Map<String, dynamic>>> addDateTimeLabelToMap(
    Future<List<Map<String, dynamic>>> list) async {
  for (var map in await list) {
    final dateTime = DateTime(map[DatabaseHelper.columnYear],map[DatabaseHelper.columnMonth],map[DatabaseHelper.columnDay]);
    map.addAll({SeparateLabelMapKey().dateTime: dateTime});
  }
  return list;
}

Future<List<Map<String, dynamic>>> makeMutable(
    Future<List<Map<String, dynamic>>> mapsList) async {
  List<Map<String, dynamic>> oldList = await mapsList;
  List<Map<String, dynamic>> newList = [];
  for (var map in oldList) {
    Map<String, dynamic> newMap = Map<String, dynamic>.from(map);
    newList.add(newMap);
  }
  return newList;
}
