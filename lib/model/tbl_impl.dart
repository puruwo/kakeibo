import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tableNameKey.dart';

//DatabaseHelperの初期化
DatabaseHelper db = DatabaseHelper.instance;

//Paymentの操作
class TBL001Impl {
  //月またぎ、1月分取得(Mutable)
  Future<List<Map<String, dynamic>>> queryCrossMonthMutableRows(
      DateTime fromDate, DateTime toDate) async {
    //where句の作成
    //一周期の条件指定が難しいのでここで作成
    //ex)
    //from 2023-06-25 to 2023-07-24なら
    //(year = 2023 and month = 6 and day >= 25 and day <= 31) or (year = 2023 and month = 7 and day >= 1 and day <=25)
    final where =
        '(${TBL001RecordKey().year} = ? and ${TBL001RecordKey().month} = ? and  ${TBL001RecordKey().day} >= ? and ${TBL001RecordKey().day} <= ?) or (${TBL001RecordKey().year} = ? and ${TBL001RecordKey().month} = ?  and ${TBL001RecordKey().day} >= ? and ${TBL001RecordKey().day} <= ?)';
    final whereArgs = [
      fromDate.year,
      fromDate.month,
      fromDate.day,
      DateTime(fromDate.year, fromDate.month + 1, 0).day, //fromDateの最終日
      toDate.year,
      toDate.month,
      1,
      toDate.day
    ];

    final immutable =
        db.queryRowsWhere(TBL001RecordKey().tableName, where, whereArgs);
    final mutable = makeMutable(immutable);

    final addedDateInformationMap = addDateTimeLabelToMap(mutable);

    //tbl001_recordのカラム(_id,year,month,day,price,category,memo)に加えて
    //'stringDate' もある
    return addedDateInformationMap;
  }

  //1日分取得(Mutable)
  Future<List<Map<String, dynamic>>> queryDayMutableRows(DateTime date) async {
    //where句の作成
    //一周期の条件指定が難しいのでここで作成
    //ex)
    //from 2023-06-25 to 2023-07-24なら
    //(year = 2023 and month = 6 and day >= 25 and day <= 31) or (year = 2023 and month = 7 and day >= 1 and day <25)
    final where =
        '(${TBL001RecordKey().year} = ? and ${TBL001RecordKey().month} = ? and  ${TBL001RecordKey().day} = ? )';
    final whereArgs = [date.year, date.month, date.day];

    final immutable =
        db.queryRowsWhere(TBL001RecordKey().tableName, where, whereArgs);
    final mutable = makeMutable(immutable);

    return mutable;
  }

  //全データ取得
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return db.queryRows(TBL001RecordKey().tableName);
  }

  //DateTimeのラベル付与
  Future<List<Map<String, dynamic>>> addDateTimeLabelToMap(
      Future<List<Map<String, dynamic>>> list) async {
    for (var map in await list) {
      final dateTime = DateTime(map[TBL001RecordKey().year],
          map[TBL001RecordKey().month], map[TBL001RecordKey().day]);
      map.addAll({SeparateLabelMapKey().dateTime: dateTime});
    }
    return list;
  }
}

//Paymentの操作
class TBL002Impl {
  //月またぎ、1月分取得(Mutable)
  Future<List<Map<String, dynamic>>> queryCrossMonthMutableRows(
      DateTime fromDate, DateTime toDate) async {
    //where句の作成
    //一周期の条件指定が難しいのでここで作成
    //ex)
    //from 2023-06-25 to 2023-07-24なら
    //(year = 2023 and month = 6 and day >= 25 and day <= 31) or (year = 2023 and month = 7 and day >= 1 and day <25)
    final where =
        '(${TBL002RecordKey().year} = ? and ${TBL002RecordKey().month} = ? and  ${TBL002RecordKey().day} >= ? and ${TBL002RecordKey().day} <= ?) or (${TBL002RecordKey().year} = ? and ${TBL002RecordKey().month} = ?  and ${TBL002RecordKey().day} >= ? and ${TBL002RecordKey().day} < ?)';
    final whereArgs = [
      fromDate.year,
      fromDate.month,
      fromDate.day,
      DateTime(fromDate.year, fromDate.month + 1, 0).day, //fromDateの最終日
      toDate.year,
      toDate.month,
      1,
      toDate.day
    ];

    final immutable =
        db.queryRowsWhere(TBL002RecordKey().tableName, where, whereArgs);
    final mutable = makeMutable(immutable);

    final addedDateInformationMap = addDateTimeLabelToMap(mutable);

    //tbl002_recordのカラム(_id,year,month,day,price,category,memo)に加えて
    //'stringDate' もある
    return addedDateInformationMap;
  }

  //1日分取得(Mutable)
  Future<List<Map<String, dynamic>>> queryDayMutableRows(DateTime date) async {
    //where句の作成
    //一周期の条件指定が難しいのでここで作成
    //ex)
    //from 2023-06-25 to 2023-07-24なら
    //(year = 2023 and month = 6 and day >= 25 and day <= 31) or (year = 2023 and month = 7 and day >= 1 and day <25)
    final where =
        '(${TBL002RecordKey().year} = ? and ${TBL002RecordKey().month} = ? and  ${TBL002RecordKey().day} = ? )';
    final whereArgs = [date.year, date.month, date.day];

    final immutable =
        db.queryRowsWhere(TBL002RecordKey().tableName, where, whereArgs);
    final mutable = makeMutable(immutable);

    return mutable;
  }

  //全データ取得
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return db.queryRows(TBL002RecordKey().tableName);
  }

  //DateTimeのラベル付与
  Future<List<Map<String, dynamic>>> addDateTimeLabelToMap(
      Future<List<Map<String, dynamic>>> list) async {
    for (var map in await list) {
      final dateTime = DateTime(map[TBL002RecordKey().year],
          map[TBL002RecordKey().month], map[TBL002RecordKey().day]);
      map.addAll({SeparateLabelMapKey().dateTime: dateTime});
    }
    return list;
  }
}

//bigCategory指定で一ヶ月分のレコードの取得
//月またぎ、1月分取得(Mutable)
Future<List<Map<String, dynamic>>> queryCrossMonthMutableRowsByBigCategory(
    DateTime fromDate, DateTime toDate) async {
      final sql = '''
                SELECT c.${TBL004RecordKey().id},c.${TBL004RecordKey().bigCategoryName},SUM(a.${TBL001RecordKey().price}) as sum_price,c.${TBL004RecordKey().resourcePath}, e.${TBL005RecordKey().price} as budget FROM Payment a
                INNER JOIN  Category b
                INNER JOIN BigCategoryInfo c
                INNER JOIN (SELECT * FROM ${TBL005RecordKey().tableName} d
                            WHERE d.${TBL005RecordKey().yyyy} = 2024 and d.${TBL005RecordKey().mm} = 1) e
                on a.payment_category_id = b._id
                AND b.big_category_key = c._id
                WHERE ((a.year = ${fromDate.year} and a.month = ${fromDate.month} and a.day >= ${fromDate.day} and a.day <= 31)
                 or (a.year = ${toDate.year} and a.month = ${toDate.month} and a.day >= 1 and a.day <= ${toDate.day}))
                AND c.${TBL004RecordKey().id} = e.${TBL005RecordKey().bigCategoryId}
                AND c.is_displayed = 1
                GROUP BY c.big_category_name
                ORDER BY c.display_order 
                ''';

  //目標の取得でデグレを起こしている、要修正
  // final sql = '''
  //               SELECT c.${TBL004RecordKey().id},c.${TBL004RecordKey().bigCategoryName},SUM(a.${TBL001RecordKey().price}) as sum_price,c.${TBL004RecordKey().resourcePath}, e.${TBL005RecordKey().price} as budget FROM Payment a
  //               INNER JOIN  Category b
  //               INNER JOIN BigCategoryInfo c
  //               INNER JOIN (SELECT * FROM ${TBL005RecordKey().tableName} d
  //                           WHERE d.${TBL005RecordKey().yyyy} = ${fromDate.year} and d.${TBL005RecordKey().mm} = ${fromDate.month}) e
  //               on a.payment_category_id = b._id
  //               AND b.big_category_key = c._id
  //               WHERE ((a.year = ${fromDate.year} and a.month = ${fromDate.month} and a.day >= ${fromDate.day} and a.day <= 31)
  //                or (a.year = ${toDate.year} and a.month = ${toDate.month} and a.day >= 1 and a.day <= ${toDate.day}))
  //               AND c.${TBL004RecordKey().id} = e.${TBL005RecordKey().bigCategoryId}
  //               AND c.is_displayed = 1
  //               GROUP BY c.big_category_name
  //               ORDER BY c.display_order 
  //               ''';

  final immutable = db.query(sql);
  final mutable = await makeMutable(immutable);

  int i = 0;
  for (var item in mutable) {
    final sql = '''
                SELECT b.${TBL003RecordKey().categoryName}, c.sum_by_category FROM ${TBL004RecordKey().tableName} a
                INNER JOIN ${TBL003RecordKey().tableName} b
                INNER JOIN (SELECT SUM(${TBL001RecordKey().price}) as sum_by_category, a.${TBL001RecordKey().paymentCategoryId} FROM ${TBL001RecordKey().tableName} a
                GROUP BY a.${TBL001RecordKey().paymentCategoryId}) c
                on a.${TBL004RecordKey().id} = b.${TBL003RecordKey().bigCategoryKey}
                AND b.${TBL003RecordKey().smallCategoryKey}= c.${TBL001RecordKey().paymentCategoryId}
                WHERE a.${TBL004RecordKey().isDisplayed} = 1
                AND a.${TBL004RecordKey().id} = ${item[TBL004RecordKey().id]}
                ORDER BY b.${TBL003RecordKey().id}
                ''';

    final immutable2 = db.query(sql);
    final mutable2 = await makeMutable(immutable2);
    mutable[i].addAll({'smallCategoryMaps' : mutable2});
    i++;
  }

  return mutable;
}

//bigCategory指定で一ヶ月分のカテゴリーごとのレコードの取得
//月またぎ、1月分取得(Mutable)
Future<List<Map<String, dynamic>>> queryCrossMonthMutableRowsByCategory(
    int category, DateTime fromDate, DateTime toDate) async {
  final sql = '''
                SELECT b.${TBL003RecordKey().categoryName}, c.sum_by_category FROM ${TBL004RecordKey().tableName} a
                INNER JOIN ${TBL003RecordKey().tableName} b
                INNER JOIN (SELECT SUM(${TBL001RecordKey().price}) as sum_by_category, a.${TBL001RecordKey().paymentCategoryId} FROM ${TBL001RecordKey().tableName} a
                GROUP BY a.${TBL001RecordKey().paymentCategoryId}) c
                on a.${TBL004RecordKey().id} = b.${TBL003RecordKey().bigCategoryKey}
                AND b.${TBL003RecordKey().smallCategoryKey}= c.${TBL001RecordKey().paymentCategoryId}
                WHERE a.${TBL004RecordKey().isDisplayed} = 1
                AND a.${TBL004RecordKey().id} = ${category}
                ORDER BY b.${TBL003RecordKey().id}
                ''';

  final immutable = db.query(sql);
  final mutable = makeMutable(immutable);

  return mutable;
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
