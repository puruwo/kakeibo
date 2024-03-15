import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakeibo/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:kakeibo/repository/tbl001_record/tbl001_record.dart';
import 'package:kakeibo/repository/torok_record/torok_record.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:collection';
// DateTimeの日本語対応
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:kakeibo/util/util.dart';

import 'package:kakeibo/view/page/torok.dart';

import 'package:kakeibo/view_model/provider/active_datetime.dart';
import 'package:kakeibo/view_model/provider/update_DB_count.dart';
import 'package:kakeibo/view_model/reference_day_impl.dart';

import 'package:kakeibo/model/tbl_impl.dart';
import 'package:kakeibo/model/tableNameKey.dart';
import 'package:kakeibo/model/assets_conecter/category_handler.dart';

class ExpenceHistoryArea extends ConsumerStatefulWidget {
  ExpenceHistoryArea({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpenceHistoryAreaState();

  final AutoScrollController _scrollController = AutoScrollController();
}

class _ExpenceHistoryAreaState extends ConsumerState<ExpenceHistoryArea> {
  late SplayTreeMap<String, dynamic> sortedGroupedMap;

  @override
  Widget build(BuildContext context) {
    // 消す
    print('expence_history_list_area is built');

    // DateTimeの日本語対応
    initializeDateFormatting();

//状態管理---------------------------------------------------------------------------------------

    //databaseに操作がされた場合にカウントアップされるprovider
    ref.watch(updateDBCountNotifierProvider);

    final activeDateTime = ref.watch(activeDatetimeNotifierProvider);

    // 消す
    print('activeDatetime is $activeDateTime in expence_history_list_area');

    // activeDatetimeが更新されたら動く
    ref.listen(activeDatetimeNotifierProvider, (previous, next) {
      // ビルドが終わったら動く
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final updatedActiveDateTime = ref.read(activeDatetimeNotifierProvider);
        // DateTimeで並べ替えたMapのKeyをリストとして取得
        final itemKeys = List.from(sortedGroupedMap.keys);
        _scrollToItem(
            updatedActiveDateTime, itemKeys, widget._scrollController);
      });
    });

//----------------------------------------------------------------------------------------------
//データ取得--------------------------------------------------------------------------------------

    //集計スタートの日
    final fromDate = getReferenceDay(activeDateTime);

    //集計終了の日
    //次の基準日を取得しているので、そこから1引いて集計終了日を算出
    final dtBuff = getNextReferenceDay(activeDateTime);
    final toDate = dtBuff.add(const Duration(days: -1));

    final Future<List<Map<String, dynamic>>> rows =
        TBL001Impl().queryCrossMonthMutableRows(fromDate, toDate);

//----------------------------------------------------------------------------------------------

    return FutureBuilder(
        future: rows,
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          Widget children;

          if (snapshot.hasData) {
            //snapShotのリストを分割する
            final groupedMap = snapshot.data!
                .groupListsBy<String>((e) => e[TBL001RecordKey().date]);
            //Mapのキーで上から降順に並び替える
            //型指定してやらんとエラーになる、Object型で判定されるため
            sortedGroupedMap = SplayTreeMap.from(
                groupedMap, (String key1, String key2) => key2.compareTo(key1));

            return Expanded(
              child: ListView.builder(
                controller: widget._scrollController,
                itemCount: sortedGroupedMap.length,
                itemBuilder: (BuildContext context, int index) {
                  String date = sortedGroupedMap.keys.elementAt(index);
                  List<Map> itemsInADay = sortedGroupedMap[date]!;
                  List<Map> descendingOrderItems =
                      descendingOrderSort(itemsInADay);

                  final stringDate = formattedLabelDateGetter(date);
                  return AutoScrollTag(
                    key: ValueKey(index),
                    index: index,
                    controller: widget._scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 日付ヘッダーの上スペース
                        const SizedBox(
                          height: 13,
                        ),
                        //日付ラベル
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 14.5),
                              child: Text(stringDate,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: MyColors.secondaryLabel,
                                  )),
                            ),
                            //右余白
                          ],
                        ),

                        //区切り線
                        const Divider(
                          thickness: 0.25,
                          height: 0.25,
                          indent: 14.5,
                          color: MyColors.separater,
                        ),

                        //タイル
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: descendingOrderItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = itemsInADay[index];

                            // アイコン
                            final icon = CategoryHandler().sisytIconGetter(
                                item[TBL001RecordKey().paymentCategoryId]);
                            // 大カテゴリー名
                            final bigCategoryName =
                                item[TBL202RecordKey().bigCategoryName];
                            // 小カテゴリー
                            final categoryName =
                                item[TBL201RecordKey().categoryName];
                            // メモ
                            final memo = item[TBL001RecordKey().memo];
                            // 値段ラベル
                            final priceLabel = formattedPriceGetter(
                                item[TBL001RecordKey().price]);

                            return Column(
                              children: [
                                Dismissible(
                                  // 右から左
                                  direction: DismissDirection.endToStart,
                                  key: Key(
                                      item[TBL001RecordKey().id].toString()),
                                  dragStartBehavior: DragStartBehavior.start,

                                  // 右スワイプ時の背景
                                  background: Container(color: MyColors.black),

                                  // 左スワイプ時の背景
                                  secondaryBackground: Container(
                                    color: MyColors.red,
                                    child: const Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          // 削除時背景のアイコンのpadding
                                          padding: EdgeInsets.only(right: 18.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: MyColors.systemGray,
                                          ),
                                        )),
                                  ),
                                  child: GestureDetector(
                                    child: SizedBox(
                                      height: 49,
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // アイコン
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 18),
                                            child: icon,
                                          ),

                                          // 大カテゴリー、小カテゴリーのColumn
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // 大カテゴリー
                                                Text(
                                                  bigCategoryName,
                                                  textAlign: TextAlign.end,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color:
                                                        MyColors.secondaryLabel,
                                                  ),
                                                ),

                                                // 小カテゴリーとメモ
                                                Row(
                                                  children: [
                                                    // 小カテゴリー
                                                    SizedBox(
                                                      width: 60,
                                                      child: Text(
                                                        ' $categoryName',
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: MyColors
                                                                .tirtiaryLabel),
                                                      ),
                                                    ),
                                                    // メモ
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        ' $memo',
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: MyColors
                                                                .tirtiaryLabel),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),

                                          // 値段
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 22.0),
                                            child: Text(
                                              priceLabel,
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 19,
                                                  color: MyColors.label),
                                            ),
                                          ),

                                          // nextArrowアイコン
                                          const Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              size: 18,
                                              Icons.arrow_forward_ios_rounded,
                                              color: MyColors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      showCupertinoModalBottomSheet(
                                        //sccafoldの上に出すか
                                        useRootNavigator: true,
                                        //縁タップで閉じる
                                        isDismissible: true,
                                        context: context,
                                        builder: (_) => Torok.origin(
                                          torokRecord: TorokRecord(
                                              date: item[
                                                  SeparateLabelMapKey().date],
                                              id: item[
                                                  SeparateLabelMapKey().id],
                                              price: item[
                                                  SeparateLabelMapKey().price],
                                              memo: item[
                                                  SeparateLabelMapKey().memo],
                                              category: item[
                                                  SeparateLabelMapKey()
                                                      .category]),
                                          screenMode: 1,
                                        ),
                                      );
                                    },
                                  ),

                                  //タイルを横にスライドした時の処理
                                  confirmDismiss: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text("Confirm"), // ダイアログのタイトル
                                            content: Text(
                                                "Are you sure you wish to delete this item?"), // ダイアログのメッセージ
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(
                                                        false), // キャンセルボタンを押したときの処理
                                                child: Text("CANCEL"),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(
                                                        true), // 削除ボタンを押したときの処理
                                                child: Text("DELETE"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },

                                  //ダイアログでOKを押したら処理
                                  onDismissed: (direction) {
                                    final record = TBL001Record(
                                      id: item[TBL001RecordKey().id],
                                      category: item[
                                          TBL001RecordKey().paymentCategoryId],
                                      price: item[TBL001RecordKey().price],
                                      memo: item[TBL001RecordKey().memo],
                                      date: item[TBL001RecordKey().date],
                                    );
                                    record.delete();
                                    // 消す
                                    print('削除されました id:${item[TBL001RecordKey().id]}'
                                        'category:${item[TBL001RecordKey().paymentCategoryId]}'
                                        'price:${item[TBL001RecordKey().price]}'
                                        'memo:${item[TBL001RecordKey().memo]}'
                                        '${item[TBL001RecordKey().date]}年');
                                  },
                                ), //区切り線
                                const Divider(
                                  thickness: 0.25,
                                  height: 0.25,
                                  indent: 50,
                                  color: MyColors.separater,
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
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
        });
  }

  void _scrollToItem(
      DateTime dt, List keysList, AutoScrollController controller) async {
    final specificItem = DateFormat('yyyyMMdd').format(dt);
    final index = keysList.indexOf(specificItem);
    await controller.scrollToIndex(
      index,
      duration: const Duration(milliseconds: 500),
      preferPosition: AutoScrollPosition.begin,
    );
    await controller.highlight(index);
  }

  List<Map<dynamic, dynamic>> descendingOrderSort(List<Map> itemsInADay) {
    //sortはvoid関数
    itemsInADay.sort(
        ((a, b) => b[TBL001RecordKey().id].compareTo(a[TBL001RecordKey().id])));
    final sorted = itemsInADay;
    return sorted;
  }

  String formattedLabelDateGetter(String dateString) {
    // 文字列をDateTimeに変換
    DateTime dateTime = DateTime.parse(
        '${dateString.substring(0, 4)}-${dateString.substring(4, 6)}-${dateString.substring(6, 8)}');

    // 年月日と曜日のフォーマットで日付を文字列に変換
    String formattedDate = DateFormat('yyyy年M月d日(E)', 'ja_JP').format(dateTime);

    return formattedDate;
  }
}
