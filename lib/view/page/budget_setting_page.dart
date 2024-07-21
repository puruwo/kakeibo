/// packegeImport
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// localImport
import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/model/assets_conecter/category_handler.dart';

import 'package:kakeibo/model/db_read.dart';
import 'package:kakeibo/model/db_delete.dart';
import 'package:kakeibo/model/tableNameKey.dart';

import 'package:kakeibo/repository/tbl003_record/tbl003_record.dart';
import 'package:kakeibo/repository/tbl202_record/tbl202_record.dart';
import 'package:kakeibo/view/page/small_category_edit_page.dart';

import 'package:kakeibo/view_model/provider/update_DB_count.dart';
import 'package:kakeibo/view_model/provider/budget_setting_page/edit_mode.dart';

import 'package:kakeibo/view_model/reference_day_getter.dart';

class BudgetSettingPage extends ConsumerStatefulWidget {
  const BudgetSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BudgetSettingPageState();
}

class _BudgetSettingPageState extends ConsumerState<BudgetSettingPage> {
  final activeDt = DateTime.now();

  // 今月の予算データのリスト
  List<Map<String, dynamic>>? monthlyCategoryBudgetList;

  // 先月の実績データのリスト
  List<Map<String, dynamic>>? lastMonthPaymentList;

  // カテゴリーの要素クラスItemのリスト
  final List<Item> itemList = [];

  // 編集モードで予算が編集されたかどうか
  bool isBudgetEdited = false;

  // 編集モードで表示非表示が編集されたかどうか
  bool isDefaultDisplayEdited = false;

  @override
  void initState() {
    super.initState();

    // 初期化が終わる前にbuildが完了してしまうのでawait&SetStateする
    Future(() async {
      await initialize();
      setState(() {});
    });
  }

  @override
  void dispose() {
    itemList.forEach((element) {
      element.controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editmodeProvider = ref.watch(editModeNotifierProvider);

    return Scaffold(
      // ヘッダー
      appBar: AppBar(
        //ヘッダー左のアイコンボタン
        leading: IconButton(
            // 閉じるときはネストしているModal内のRouteではなく、root側のNavigatorを指定する必要がある
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            icon: const Icon(Icons.close)),

        //ヘッダー右のアイコンボタン
        actions: [
          IconButton(
            icon: editmodeProvider
                ? const Icon(
                    //完了チェックマーク
                    Icons.done_rounded,
                    color: MyColors.white,
                  )
                : const Text('編集'),
            onPressed: () {
              // 登録処理
              editmodeProvider ? registorFunction() : null;

              //DB更新のnotifier
              //DBが更新されたことをグローバルなproviderに反映
              editmodeProvider ? dbUpdateNotify() : null;

              // 編集モードの状態を更新
              final notifier = ref.read(editModeNotifierProvider.notifier);
              notifier.updateState();
              // 編集したかどうかを初期化
              isBudgetEdited = false;
              isDefaultDisplayEdited = false;
            },
          ),
        ],
      ),

      // 本体
      body: editmodeProvider == true
          ? ReorderableListView.builder(
              // 並べ替えた時の処理
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  reorderFunction(oldIndex, newIndex);
                  // 変更を加えたことを管理する状態管理する
                });
              },
              itemCount: monthlyCategoryBudgetList!.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  key: Key('$index'),
                  children: [
                    // チェックボックス
                    ElevatedButton(
                        onPressed: () {
                          // チェックボックスのタップ処理
                          setState(() {
                            final bool = itemList[index].isChecked;
                            // チェックボックスに渡す値を更新する
                            itemList[index].isChecked = !bool;
                            // 編集済みフラグを立てる
                            isDefaultDisplayEdited = true;
                          });
                        },
                        child: itemList[index].isChecked
                            ? Container(
                                height: 20,
                                width: 10,
                                color: MyColors.blue,
                              )
                            : Container(
                                height: 20,
                                width: 10,
                              )),

                    // アイコン
                    itemList[index].icon,

                    Text(
                      itemList[index].bigCategoryId.toString(),
                      style: GoogleFonts.notoSans(
                          fontSize: 16,
                          color: MyColors.label,
                          fontWeight: FontWeight.w400),
                    ),
                    const Text(' '),
                    Text(
                      itemList[index].bigCategoryName,
                      style: GoogleFonts.notoSans(
                          fontSize: 16,
                          color: MyColors.label,
                          fontWeight: FontWeight.w400),
                    ),
                    const Text(' '),
                    Text(
                      itemList[index].gotDisplayOrder.toString(),
                      style: GoogleFonts.notoSans(
                          fontSize: 16,
                          color: MyColors.label,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      itemList[index].editedDisplayOrder.toString(),
                      style: GoogleFonts.notoSans(
                          fontSize: 16,
                          color: MyColors.label,
                          fontWeight: FontWeight.w400),
                    ),
                    const Text(' '),
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: itemList[index].controller,
                        // テキストフィールドのプロパティ
                        textAlign: TextAlign.right,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(
                            color: MyColors.white, fontSize: 17),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        // 編集されたら編集フラグをtrueに
                        onChanged: (value) {
                          isBudgetEdited = true;
                        },
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
                  ],
                );
              },
            )
          // 非編集時
          : ListView.builder(
              itemCount: monthlyCategoryBudgetList!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    final bigCategoryId = itemList[index].bigCategoryId;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SmallCategoryEditPage(
                                bigCategoryId: bigCategoryId))));
                  },
                  child: Row(
                    key: Key('$index'),
                    children: [
                      // アイコン
                      itemList[index].icon,

                      Text(
                        itemList[index].bigCategoryId.toString(),
                        style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color: MyColors.label,
                            fontWeight: FontWeight.w400),
                      ),
                      const Text(' '),
                      Text(
                        itemList[index].bigCategoryName,
                        style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color: MyColors.label,
                            fontWeight: FontWeight.w400),
                      ),
                      const Text(' '),
                      Text(
                        itemList[index].gotDisplayOrder.toString(),
                        style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color: MyColors.label,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        itemList[index].editedDisplayOrder.toString(),
                        style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color: MyColors.label,
                            fontWeight: FontWeight.w400),
                      ),
                      const Text(' '),
                      Text(
                        itemList[index].controller.text,
                        style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color: MyColors.label,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // 目標データの挿入
  void registorFunction() {
    if (isBudgetEdited) {
      tBL003Impl();
      // スナックバーの表示
      doneSnackBarFunc();
    }
    if (isDefaultDisplayEdited) {
      tBL202Impl();
      // スナックバーの表示
      doneSnackBarFunc();
    }
  }

  void tBL003Impl() async {
    for (int i = 0; i < itemList.length; i++) {
      final int inputPrice = int.parse(itemList[i].controller.text);

      final int bigCategoryId = itemList[i].bigCategoryId;
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

      // 削除するべきレコードがあれば削除
      if (deletingTargetData != null) {
        int deletingTargetDataId = deletingTargetData[TBL003RecordKey().id];
        tBL003RecordDelete(deletingTargetDataId);
      }

      // 目標データの挿入
      record.insert();
    }
  }

  void tBL202Impl() {
    for (int i = 0; i < itemList.length; i++) {
      // booleanから 0 or 1 に変換
      final isDisplayed = itemList[i].isChecked == true ? 1 : 0;

      final record = TBL202Record(
        id: itemList[i].bigCategoryId,
        colorCode: itemList[i].bigCategoryColor,
        bigCategoryName: itemList[i].bigCategoryName,
        resourcePath: itemList[i].bigCategoryResourcePath,
        displayOrder: itemList[i].editedDisplayOrder,
        isDisplayed: isDisplayed,
      );

      record.update();
    }
  }

  void doneSnackBarFunc() {
    // Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('登録が完了しました'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ));
  }

  void dbUpdateNotify() {
    final notifier = ref.read(updateDBCountNotifierProvider.notifier);
    notifier.incrementState();
  }

  // initstate内の宣言
  initialize() async {
    // 目標データの取得
    // {
    //  big_category_id
    //  price
    //  color_code
    //  big_category_name
    //  resource_path
    //  display_order
    //  is_displayed
    // }
    monthlyCategoryBudgetList = await queryMonthlyCategoryBudget(activeDt);

    // 先月の実績のデータを取得
    final toDate = getReferenceDay(activeDt);
    final fromDate = getPreviousReferenceDay(toDate);
    // {
    //  sum_by_bigcategory:
    //  big_category_key:
    // }
    lastMonthPaymentList =
        await queryCrossMonthMutableRowsByCategory(fromDate, toDate);

    // itemListの初期化
    for (int i = 0; i < monthlyCategoryBudgetList!.length; i++) {
      final price = monthlyCategoryBudgetList![i]['price'].toString();
      itemList.add(Item(
        // 大カテゴリーのIDを取得
        bigCategoryId: monthlyCategoryBudgetList![i]
            [TBL003RecordKey().bigCategoryId],
        // 大カテゴリーの予算を取得
        bigCategoryBudget: monthlyCategoryBudgetList![i]['price'],
        // 大カテゴリーのcolorCodeを取得
        bigCategoryColor: monthlyCategoryBudgetList![i]
            [TBL202RecordKey().colorCode],
        // 大カテゴリーの名前を取得
        bigCategoryName: monthlyCategoryBudgetList![i]
            [TBL202RecordKey().bigCategoryName],
        // 大カテゴリーの画像パスを取得
        bigCategoryResourcePath: monthlyCategoryBudgetList![i]
            [TBL202RecordKey().resourcePath],
        // 大カテゴリーの先月の実績
        sumBigCategory: lastMonthPaymentList![i]['sum_by_bigcategory'],
        // 大カテゴリーの先月のid
        bigCategoryKey: lastMonthPaymentList![i][TBL202RecordKey().id],
        // 表示順
        gotDisplayOrder: monthlyCategoryBudgetList![i]
            [TBL202RecordKey().displayOrder],
        // 表示非表示設定
        isDisplayed: monthlyCategoryBudgetList![i]
            [TBL202RecordKey().isDisplayed],
        // コントローラー
        controller: TextEditingController(text: price),
      ));
    }
  }

  void reorderFunction(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = itemList.removeAt(oldIndex);
    itemList.insert(newIndex, item);

    // itemの表示順を更新
    //
    for (int i = 0; i < itemList.length; i++) {
      itemList[i].editedDisplayOrder = i;
    }
  }
}

class Item {
  // 大カテゴリーのIDを取得
  final int bigCategoryId;
  // 大カテゴリーの予算を取得
  final int bigCategoryBudget;
  // 大カテゴリーのcolorCodeを取得
  final String bigCategoryColor;
  // 大カテゴリーの名前を取得
  final String bigCategoryName;
  // 大カテゴリーの画像パスを取得
  final String bigCategoryResourcePath;
  // アイコンの取得
  late Widget icon;
  // 大カテゴリーの先月の実績
  final int sumBigCategory;
  // 大カテゴリーの先月のid
  final int bigCategoryKey;
  // DBから取得した表示順
  final int gotDisplayOrder;
  // 編集後表示順
  late int editedDisplayOrder;
  // DBでの表示非表示設定 0 or 1
  final int isDisplayed;
  // 表示非表示の設定
  late bool isChecked;
  // コントローラー
  final TextEditingController controller;

  Item({
    required this.bigCategoryId,
    required this.bigCategoryBudget,
    required this.bigCategoryColor,
    required this.bigCategoryName,
    required this.bigCategoryResourcePath,
    required this.sumBigCategory,
    required this.bigCategoryKey,
    required this.gotDisplayOrder,
    required this.isDisplayed,
    required this.controller,
  }) {
    // アイコンの取得
    icon = CategoryHandler().iconGetterFromPath(bigCategoryResourcePath);
    // 表示日表示の初期化
    isChecked = isDisplayed == 1 ? true : false;
    // 編集後表示順の初期化
    editedDisplayOrder = gotDisplayOrder;
  }
}
