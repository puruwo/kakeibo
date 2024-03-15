import 'package:intl/intl.dart';
import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tableNameKey.dart';

//DatabaseHelperの初期化
DatabaseHelper db = DatabaseHelper.instance;

//Paymentの操作
class TBL001Impl {
  //月またぎ、1月分取得(Mutable)
  // {
  //    '_id': 
  //    'date': 
  //    'price': 
  //    'payment_category_id': 
  //    'memo': 
  //    'category_name': 
  //    'big_category_name': 
  //    'resource_path': 
  // }
  Future<List<Map<String, dynamic>>> queryCrossMonthMutableRows(
      DateTime fromDate, DateTime toDate) async {
    final sql = '''
      SELECT a.${TBL001RecordKey().id},a.${TBL001RecordKey().date},a.${TBL001RecordKey().price},a.${TBL001RecordKey().paymentCategoryId},a.${TBL001RecordKey().memo},b.${TBL201RecordKey().categoryName},b.${TBL202RecordKey().bigCategoryName},b.${TBL202RecordKey().resourcePath} 
      FROM ${TBL001RecordKey().tableName} a
      INNER JOIN (SELECT x.${TBL201RecordKey().id},x.${TBL201RecordKey().categoryName},y.${TBL202RecordKey().bigCategoryName},y.${TBL202RecordKey().resourcePath}  
                  FROM ${TBL201RecordKey().tableName} x
                  INNER JOIN ${TBL202RecordKey().tableName} y
                  ON x.${TBL201RecordKey().bigCategoryKey} = y.${TBL202RecordKey().id}) b
      ON a.${TBL001RecordKey().paymentCategoryId} = b.${TBL201RecordKey().id}
      WHERE a.${TBL001RecordKey().date} >= ${DateFormat('yyyyMMdd').format(fromDate)} 
      AND a.${TBL001RecordKey().date} <= ${DateFormat('yyyyMMdd').format(toDate)};
      ''';
      print(sql);
    final immutable = db.query(sql);
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
    final where = '${TBL001RecordKey().date} = ? ';
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
// {
// _id:
// color_code:
// big_category_name:
// resource_path,big_category_budget:
// payment_price_sum:
// smallCategorySumAndBudgetList:{
//      {
//      _id:
//      small_category_payment_sum:
//      big_category_key:
//      tdisplayed_order_in_big:
//      category_name:
//      default_displaye:
//      }
// }
Future<List<Map<String, dynamic>>> queryCrossMonthMutableRowsByBigCategory(
    DateTime fromDate, DateTime toDate) async {
  final sql = '''
              SELECT  t1.${TBL202RecordKey().id} as ${TBL201RecordKey().bigCategoryKey}, 
                      t1.${TBL202RecordKey().colorCode},
                      t1.${TBL202RecordKey().bigCategoryName},
                      t1.${TBL202RecordKey().resourcePath},
                      t3.price as big_category_budget,COALESCE(t2.price_sum, 0) AS payment_price_sum
              FROM ${TBL202RecordKey().tableName} t1
              LEFT JOIN (
                      SELECT ${TBL201RecordKey().bigCategoryKey}, price_sum
                      FROM (SELECT y.${TBL201RecordKey().bigCategoryKey},SUM(z.${TBL001RecordKey().price}) as price_sum FROM ${TBL001RecordKey().tableName} z
              			  INNER JOIN ${TBL201RecordKey().tableName} y
              			    ON z.${TBL001RecordKey().paymentCategoryId} = y._id
              			    WHERE (z.${TBL001RecordKey().date} >= ${DateFormat('yyyyMMdd').format(fromDate)} AND z.${TBL001RecordKey().date} <=${DateFormat('yyyyMMdd').format(toDate)})
              			    GROUP BY y.${TBL201RecordKey().bigCategoryKey})
                        ) t2
              	      ON t1.${TBL202RecordKey().id} = t2.${TBL201RecordKey().bigCategoryKey}
              LEFT JOIN (
                    SELECT MAX(${TBL003RecordKey().date}) AS max_date, *
                    FROM ${TBL003RecordKey().tableName}
                    GROUP BY ${TBL003RecordKey().bigCategoryId}
                    ) t3 
              	    ON t1.${TBL202RecordKey().id} = t3.${TBL003RecordKey().bigCategoryId}
                    WHERE NOT (t1.${TBL202RecordKey().isDisplayed} = 0 AND t2.${TBL201RecordKey().bigCategoryKey} IS NULL)
                    ORDER BY t1.${TBL202RecordKey().displayOrder} ASC;
              ''';

  final immutable = db.query(sql);
  final mutable = await makeMutable(immutable);

  // expanded時に表示する小カテゴリー別の合計を取得
  int i = 0;
  for (var item in mutable) {
    final bigCategoryKey = item[TBL201RecordKey().bigCategoryKey];

    //  {
    //  _id:
    //  small_category_payment_sum:
    //  big_category_key:
    //  tdisplayed_order_in_big:
    //  category_name:
    //  default_displaye:
    //  }

    // 

    final sql = '''
                SELECT  t1.${TBL201RecordKey().id},
                        coalesce(t2.small_category_payment_sum,0) as small_category_payment_sum ,
                        t1.${TBL201RecordKey().bigCategoryKey},
                        t1.${TBL201RecordKey().displayedOrderInBig},
                        t1.${TBL201RecordKey().categoryName},
                        t1.${TBL201RecordKey().defaultDisplayed} 
                        FROM ${TBL201RecordKey().tableName} t1 
                LEFT JOIN
                        (SELECT *,SUM(x.${TBL001RecordKey().price}) as small_category_payment_sum 
                        FROM ${TBL001RecordKey().tableName} x
						            WHERE (x.${TBL001RecordKey().date} >= ${DateFormat('yyyyMMdd').format(fromDate)}  AND x.${TBL001RecordKey().date} <=${DateFormat('yyyyMMdd').format(toDate)} )
						            GROUP BY x.${TBL001RecordKey().paymentCategoryId}) t2
                ON t2.${TBL001RecordKey().paymentCategoryId} = t1.${TBL201RecordKey().id}
                INNER JOIN ${TBL202RecordKey().tableName} t3
                ON t1.${TBL201RecordKey().bigCategoryKey} = t3._id
                WHERE t1.${TBL201RecordKey().bigCategoryKey} = $bigCategoryKey
                AND NOT (t1.${TBL201RecordKey().defaultDisplayed} = 0 AND t2.small_category_payment_sum IS NULL)
                ORDER BY t1.${TBL201RecordKey().displayedOrderInBig};
                ''';
    print(sql);
    final immutable2 = db.query(sql);
    final mutable2 = await makeMutable(immutable2);
    print(mutable);
    print('\n');
    mutable[i].addAll({'smallCategorySumAndBudgetList': mutable2});
    i++;
  }

  return mutable;
}

//bigCategory指定で一ヶ月分のカテゴリーごとのレコードの取得
//月またぎ、1月分取得(Mutable)
Future<List<Map<String, dynamic>>> queryCrossMonthMutableRowsByCategory(
    int category, DateTime fromDate, DateTime toDate) async {
  final sql = '''
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

//一ヶ月合計支出の取得
Future<List<Map<String, dynamic>>> queryMonthlyAllPriceSum(
    DateTime fromDate, DateTime toDate) async {
  final sql = '''
            SELECT SUM(${TBL001RecordKey().price}) as all_price_sum FROM ${TBL001RecordKey().tableName}
            WHERE ${TBL001RecordKey().date} >= ${DateFormat('yyyyMMdd').format(fromDate)} AND ${TBL001RecordKey().date} <= ${DateFormat('yyyyMMdd').format(toDate)} 
            ;
            ''';

  final immutable = db.query(sql);
  final mutable = makeMutable(immutable);

  return mutable;
}

//一ヶ月合計目標の取得
Future<List<Map<String, dynamic>>> queryMonthlyAllBudgetSum(
    DateTime fromDate, DateTime toDate) async {
  final sql = '''
            SELECT SUM(${TBL003RecordKey().price}) as budget_sum FROM ${TBL003RecordKey().tableName} WHERE ${TBL003RecordKey().date} = 20240101
            ;
            ''';

  final immutable = db.query(sql);
  final mutable = makeMutable(immutable);

  return mutable;
}

Future<int> getDisplaySisytCategoryNumber() async {
  final sql = '''
              SELECT count(*) as count FROM ${TBL201RecordKey().tableName} a
              WHERE a.${TBL201RecordKey().defaultDisplayed} = 1
              ;
              ''';
  List<Map<String, dynamic>> listMap = await db.query(sql);
  final count = listMap[0]['count'];
  return count;
}

Future<int> getDisplaySyunyuCategoryNumber() async {
  final sql = '''
              SELECT count(*) as count FROM ${TBL211RecordKey().tableName} a
              WHERE a.${TBL211RecordKey().defaultDisplayed} = 1
              ;
              ''';
  List<Map<String, dynamic>> listMap = await db.query(sql);
  final count = listMap[0]['count'];
  return count;
}

// {
// year_month:
// sum_price:
// }
Future<List<Map<String,dynamic>>> getMonthPaymentSum(DateTime fromDate, DateTime toDate){
  final sql = '''
              SELECT SUBSTR(CAST(a.date AS STRING), 1, 6) AS year_month, COALESCE(SUM(price), 0) as sum_price FROM TBL001 a
              WHERE ${TBL001RecordKey().date} >= ${DateFormat('yyyyMMdd').format(fromDate)} AND ${TBL001RecordKey().date} <= ${DateFormat('yyyyMMdd').format(toDate)};
              ''';
  final immutable = db.query(sql);
  final mutable = makeMutable(immutable);

  return mutable; 
}

// {
// year_month:
// sum_price:
// }
Future<List<Map<String,dynamic>>> getMonthIncomeSum(DateTime fromDate, DateTime toDate){
  final sql = '''
              SELECT SUBSTR(CAST(a.date AS STRING), 1, 6) AS year_month, COALESCE(SUM(price), 0) as sum_price FROM TBL002 a
              WHERE ${TBL002RecordKey().date} >= ${DateFormat('yyyyMMdd').format(fromDate)} AND ${TBL002RecordKey().date} <= ${DateFormat('yyyyMMdd').format(toDate)};
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


