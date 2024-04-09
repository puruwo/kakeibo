/// packegeImport
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// localImport
import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/model/assets_conecter/category_handler.dart';

import 'package:kakeibo/model/db_read_impl.dart';
import 'package:kakeibo/model/db_delete_impl.dart';
import 'package:kakeibo/model/tableNameKey.dart';

import 'package:kakeibo/repository/tbl003_record/tbl003_record.dart';
import 'package:kakeibo/view_model/provider/update_DB_count.dart';
import 'package:kakeibo/view_model/reference_day_impl.dart';

class BudgetSettingPage extends ConsumerStatefulWidget {
  const BudgetSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BudgetSettingPageState();
}

class _BudgetSettingPageState extends ConsumerState<BudgetSettingPage> {

  final activeDt = DateTime.now();

  // 今月の予算データのリスト
  late Future<List<Map<String, dynamic>>> monthlyCategoryBudgetListFuture;

  // 先月の実績データのリスト
  late Future<List<Map<String, dynamic>>> lastMonthPaymentListFuture;

  // 値段入力のコントローラ
  final List<TextEditingController> controllerList = [];

  @override
  void dispose() {
    controllerList.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 目標データの取得
    // {
    //  big_category_id
    //  price
    //  color_code
    //  big_category_name
    //  resource_path
    // }
    final monthlyCategoryBudgetListFuture =
        queryMonthlyCategoryBudget(activeDt);

    // 先月の実績のデータを取得
    final toDate = getReferenceDay(activeDt);
    final fromDate = getPreviousReferenceDay(toDate);
    // {
    //  sum_by_bigcategory:
    //  big_category_key:
    // }
    final lastMonthPaymentListFuture =
        queryCrossMonthMutableRowsByCategory(fromDate, toDate);

    return Scaffold(
      // ヘッダー
      appBar: AppBar(
        //ヘッダー右のアイコンボタン
        actions: [
          IconButton(
            icon: const Icon(
              //完了チェックマーク
              Icons.done_rounded,
              color: MyColors.white,
            ),
            onPressed: () {
              registorBudget(monthlyCategoryBudgetListFuture);

              // スナックバーの表示と画面のpop
              doneSnackBarFunc();

              //DB更新のnotifier
              //DBが更新されたことをグローバルなproviderに反映
              dbUpdateNotify();
            },
          ),
        ],
      ),

      // 本体
      body: FutureBuilder(
          future: Future.wait(
              [monthlyCategoryBudgetListFuture, lastMonthPaymentListFuture]),
          builder: (BuildContext context, snapshot) {
            Widget children;

            if (snapshot.hasData) {
              final monthlyCategoryBudgetList = snapshot.data![0];
              final lastMonthPaymentList = snapshot.data![1];

              // TextEditingControllerの初期化
              for (int i = 0; i < monthlyCategoryBudgetList.length; i++) {
                final price = monthlyCategoryBudgetList[i]['price'].toString();
                controllerList.add(TextEditingController(text: price));
              }

              return ListView.builder(
                itemCount: monthlyCategoryBudgetList.length,
                itemBuilder: (BuildContext context, int index) {
                  // 大カテゴリーのIDを取得
                  final bigCategoryId = monthlyCategoryBudgetList[index]
                      [TBL003RecordKey().bigCategoryId];
                  // 大カテゴリーの予算を取得
                  final bigCategoryBudget =
                      monthlyCategoryBudgetList[index]['price'];
                  // 大カテゴリーのcolorCodeを取得
                  final bigCategoryColor = monthlyCategoryBudgetList[index]
                      [TBL202RecordKey().colorCode];
                  // 大カテゴリーの名前を取得
                  final bigCategoryName = monthlyCategoryBudgetList[index]
                      [TBL202RecordKey().bigCategoryName];
                  // 大カテゴリーの画像パスを取得
                  final bigCategoryResourcePath =
                      monthlyCategoryBudgetList[index]
                          [TBL202RecordKey().resourcePath];
              
                  // アイコンの取得
                  final icon = CategoryHandler()
                      .iconGetterFromPath(bigCategoryResourcePath);
              
                  // 大カテゴリーの先月の実績
                  final sumBigCategory =
                      lastMonthPaymentList[index]['sum_by_bigcategory'];
                  // 大カテゴリーの先月のid
                  final bigCategoryKey =
                      lastMonthPaymentList[index][TBL202RecordKey().id];
              
                  return Row(
                    children: [
                      icon,
                      Text(
                        bigCategoryId.toString(),
                        style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color: MyColors.label,
                            fontWeight: FontWeight.w400),
                      ),
                      const Text(' '),
                      Text(
                        bigCategoryName,
                        style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color: MyColors.label,
                            fontWeight: FontWeight.w400),
                      ),
                      const Text(' '),
                      Text(
                        sumBigCategory.toString(),
                        style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color: MyColors.label,
                            fontWeight: FontWeight.w400),
                      ),
                      const Text(' '),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: controllerList[index],
                          // テキストフィールドのプロパティ
                          textAlign: TextAlign.right,
                          textAlignVertical: TextAlignVertical.top,
                          style: const TextStyle(
                              color: MyColors.white, fontSize: 17),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          // //領域外をタップでproviderを更新する
                          onTapOutside: (event) {
                            //キーボードを閉じる
                            FocusScope.of(context).unfocus();
                          },
                          onEditingComplete: () {
                            //キーボードを閉じる
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                      Text(
                        bigCategoryKey.toString(),
                        style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color: MyColors.label,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              children = Container(
                  child: const Text(
                'データが見つかりません',
                style: TextStyle(color: MyColors.white),
              ));
            } else {
              children = const CircularProgressIndicator();
            }

            return children;
          }),
    );
  }

  // 目標データの挿入
  void registorBudget(
      Future<List<Map<String, dynamic>>>
          monthlyCategoryBudgetListFuture) async {
    // DBから取得した今月の予算リスト
    final monthlyCategoryBudgetList = await monthlyCategoryBudgetListFuture;

    for (int i = 0; i < monthlyCategoryBudgetList.length; i++) {
      final int initialPrice =
          monthlyCategoryBudgetList[i][TBL003RecordKey().price];
      final int inputPrice = int.parse(controllerList[i].text);

      // 最初に取得した値段と入力した値段が違っており更新されれば挿入する
      if (initialPrice != inputPrice) {
        final int bigCategoryId =
            monthlyCategoryBudgetList[i][TBL003RecordKey().bigCategoryId];
        final int price = inputPrice;
        final String date = DateFormat('yyyyMMdd').format(DateTime.now());

        // 目標データのインスタンス化
        final record =
            TBL003Record(date: date, bigCategory: bigCategoryId, price: price);

        // 日付被りのデータを一行取得
        final listBuff =
            await getSpecifiedDateBigCategoryBudget(date, bigCategoryId);
        Map? deletingTargetData;
        if (listBuff.isNotEmpty) {
          deletingTargetData = listBuff[0];
        }
        
        print('削除');
        // 削除するべきレコードがあれば削除
        if (deletingTargetData!= null) {
          int deletingTargetDataId = deletingTargetData[TBL003RecordKey().id];
          tBL003RecordDelete(deletingTargetDataId);
        }

        print('挿入');
        // 目標データの挿入
        record.insert();
      }
    }
  }

  void doneSnackBarFunc() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('登録が完了しました'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ));
  }

  void dbUpdateNotify() {
    final notifier2 = ref.read(updateDBCountNotifierProvider.notifier);
    notifier2.incrementState();
  }
}