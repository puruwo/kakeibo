import 'package:intl/intl.dart';
import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tableNameKey.dart';

//DatabaseHelperの初期化
DatabaseHelper db = DatabaseHelper.instance;

//Paymentの操作
class TBL001Impl {
  //月またぎ、1月分取得(Mutable)
  Future<List<Map<String, dynamic>>> queryCrossMonthMutableRows(
      DateTime fromDate, DateTime toDate) async {
    final immutable = db.query(
      '''
      SELECT * FROM ${TBL001RecordKey().tableName}
      WHERE ${TBL001RecordKey().date} >= ${DateFormat('yyyyMMdd').format(fromDate)} 
      AND ${TBL001RecordKey().date} <= ${DateFormat('yyyyMMdd').format(toDate)}
      '''
    );
    final mutable = makeMutable(immutable);
    return mutable;
  }

  //1日分取得(Mutable)
  Future<List<Map<String, dynamic>>> queryDayMutableRows(DateTime date) async {
    //where句の作成
    //一周期の条件指定が難しいのでここで作成
    //ex)
    //from 2023-06-25 to 2023-07-24なら
    //(year = 2023 and month = 6 and day >= 25 and day <= 31) or (year = 2023 and month = 7 and day >= 1 and day <25)
    final where =
        '${TBL001RecordKey().date} = ? ';
    final whereArgs = [DateFormat('yyyyMMdd').format(date)];

    final immutable =
        db.queryRowsWhere(TBL001RecordKey().tableName, where, whereArgs);
    final mutable = makeMutable(immutable);

    return mutable;
  }

  //全データ取得
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return db.queryRows(TBL001RecordKey().tableName);
  }
}

//bigCategory指定で一ヶ月分のレコードの取得
//目標とアイコンやアイコンカラーもMapに含まれる
//月またぎ、1月分取得(Mutable)
Future<List<Map<String, dynamic>>> queryCrossMonthMutableRowsByBigCategory(
    DateTime fromDate, DateTime toDate) async {
      final sql = 
                '''
                SELECT c.${TBL202RecordKey().id},c.${TBL202RecordKey().bigCategoryName},SUM(a.${TBL001RecordKey().price}) as sum_price,c.${TBL202RecordKey().resourcePath}, e.${TBL003RecordKey().price} as budget 
                FROM ${TBL001RecordKey().tableName} a
                INNER JOIN  ${TBL201RecordKey().tableName} b
                INNER JOIN ${TBL202RecordKey().tableName} c
                INNER JOIN (SELECT * FROM ${TBL003RecordKey().tableName} d)e
                on a.${TBL001RecordKey().paymentCategoryId} = b._id
                AND b.${TBL201RecordKey().bigCategoryKey} = c._id
                WHERE  (a.${TBL001RecordKey().date} >= ${DateFormat('yyyyMMdd').format(fromDate)} and a.${TBL001RecordKey().date} <= ${DateFormat('yyyyMMdd').format(toDate)} )
                AND c.${TBL202RecordKey().id} = e.${TBL003RecordKey().bigCategoryId}
                AND c.${TBL202RecordKey().isDisplayed} = 1
                GROUP BY c.${TBL202RecordKey().bigCategoryName}
                ORDER BY c.${TBL202RecordKey().displayOrder}
                ''';

  final immutable = db.query(sql);
  final mutable = await makeMutable(immutable);

  // 小カテゴリー別の合計を取得
  int i = 0;
  for (var item in mutable) {
    final sql = 
              '''
              SELECT b.${TBL201RecordKey().categoryName}, c.sum_by_category FROM ${TBL202RecordKey().tableName} a
              INNER JOIN ${TBL201RecordKey().tableName} b
              INNER JOIN (SELECT SUM(${TBL001RecordKey().price}) as sum_by_category, a.${TBL001RecordKey().paymentCategoryId} FROM ${TBL001RecordKey().tableName} a
              GROUP BY a.${TBL001RecordKey().paymentCategoryId}) c
              on a.${TBL202RecordKey().id} = b.${TBL201RecordKey().bigCategoryKey}
              AND b.${TBL201RecordKey().id}= c.${TBL001RecordKey().paymentCategoryId}
              WHERE a.${TBL202RecordKey().isDisplayed} = 1
              AND a.${TBL202RecordKey().id} = ${item[TBL202RecordKey().id]}
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
  final sql = 
            '''
            SELECT b.${TBL201RecordKey().categoryName}, c.sum_by_category FROM ${TBL202RecordKey().tableName} a
            INNER JOIN ${TBL201RecordKey().tableName} b
            INNER JOIN (SELECT SUM(${TBL001RecordKey().price}) as sum_by_category, a.${TBL001RecordKey().paymentCategoryId} 
                        FROM ${TBL001RecordKey().tableName} a
                        WHERE ${TBL001RecordKey().date} >= ${DateFormat('yyyyMMdd').format(fromDate)} AND ${TBL001RecordKey().date} <= ${DateFormat('yyyyMMdd').format(toDate)}  
                        GROUP BY a.${TBL001RecordKey().paymentCategoryId}) c
            on a.${TBL202RecordKey().id} = b.${TBL201RecordKey().bigCategoryKey}
            AND b.${TBL201RecordKey().id}= c.${TBL001RecordKey().paymentCategoryId}
            WHERE a.${TBL202RecordKey().isDisplayed} = 1
            AND a.${TBL202RecordKey().id} = $category
            AND 
            ORDER BY b.${TBL201RecordKey().id}
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
