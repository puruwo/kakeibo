import 'package:kakeibo/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:kakeibo/repository/tbl001_record/tbl001_record.dart';
import 'package:kakeibo/repository/torok_record/torok_record.dart';
import 'package:kakeibo/view_model/provider/torok_state/torok_state.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:collection';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:kakeibo/model/assets_conecter/category_handler.dart';

import 'package:kakeibo/view/page/torok.dart';

import 'package:kakeibo/view_model/provider/active_datetime.dart';
import 'package:kakeibo/view_model/provider/update_DB_count.dart';
import 'package:kakeibo/view_model/reference_day_impl.dart';

import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tbl_impl.dart';
import 'package:kakeibo/model/tableNameKey.dart';

class ExpenceHistoryArea extends ConsumerWidget {
  const ExpenceHistoryArea({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
//状態管理---------------------------------------------------------------------------------------

    //databaseに操作がされた場合にカウントアップされるprovider
    ref.watch(updateDBCountNotifierProvider);

    final activeDateTime = ref.watch(activeDatetimeNotifierProvider);

    AutoScrollController _scrollController = AutoScrollController();

//----------------------------------------------------------------------------------------------
//データ取得--------------------------------------------------------------------------------------

    //集計スタートの日
    final fromDate = getReferenceDay(activeDateTime);

    //集計終了の日
    //次の基準日を取得しているので、そこから1引いて集計終了日を算出
    final dtBuff = getNextReferenceDay(activeDateTime);
    final toDate = dtBuff.add(const Duration(days: -1));

    final Future<List<Map<String, dynamic>>> dayMaps =
        TBL001Impl().queryCrossMonthMutableRows(fromDate, toDate);

    return FutureBuilder(
        future: dayMaps,
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          Widget children;

          if (snapshot.hasData) {
            //snapShotのリストを分割する
            final groupedMap =
                snapshot.data!.groupListsBy<String>((e) => e[TBL001RecordKey().date]);
            //Mapのキーで上から降順に並び替える
            //型指定してやらんとエラーになる、Object型で判定されるため
            final sortedGroupedMap = SplayTreeMap.from(groupedMap,
                (String key1, String key2) => key2.compareTo(key1));

            //DateTimeで並べ替えたMapのKeyをリストとして取得
            final keys = List.from(sortedGroupedMap.keys);
            _scrollToItem(activeDateTime, keys, _scrollController);

            return Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: sortedGroupedMap.length,
                itemBuilder: (BuildContext context, int index) {
                  String date = sortedGroupedMap.keys.elementAt(index);
                  List<Map> itemsInADay = sortedGroupedMap[date]!;
                  List<Map> descendingOrderItems =
                      descendingOrderSort(itemsInADay);

                  final stringDate = date;
                  return AutoScrollTag(
                    key: ValueKey(index),
                    index: index,
                    controller: _scrollController,
                    child: Column(
                      children: [
                        //日付ラベル
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(stringDate,
                                style: const TextStyle(
                                    color: MyColors.dimGray,
                                    fontWeight: FontWeight.bold)),
                            //右余白
                            const SizedBox(
                              height: 25,
                              width: 250,
                            )
                          ],
                        ),

                        //区切り線
                        const Divider(
                          thickness: 1,
                          height: 1,
                          color: MyColors.dimGray,
                        ),

                        //タイル
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: descendingOrderItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = itemsInADay[index];
                            return Dismissible(
                              key: Key(item[TBL001RecordKey().id].toString()),
                              child: Column(
                                children: [
                                  Container(
                                    height: 49,
                                    width: double.infinity,
                                    color: MyColors.eerieBlack,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.only(
                                          left: 0.0, right: 0.0),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CategoryHandler().iconGetter(item[
                                              TBL001RecordKey()
                                                  .paymentCategoryId]),
                                          Text(
                                            item[TBL001RecordKey().id].toString(),
                                            style: const TextStyle(
                                                color: MyColors.white),
                                          ),
                                          SizedBox(
                                              width: 192,
                                              child: FutureBuilder(
                                                  future: CategoryHandler()
                                                      .categoryNameGetter(item[
                                                          TBL001RecordKey()
                                                              .paymentCategoryId]),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data != null) {
                                                      return Text(
                                                        snapshot.data!,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: const TextStyle(
                                                            color:
                                                                MyColors.white),
                                                      );
                                                    } else {
                                                      return const Text('');
                                                    }
                                                  })),
                                          SizedBox(
                                            width: 87,
                                            child: Text(
                                              item[TBL001RecordKey().price].toString(),
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  color: MyColors.white),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: MyColors.blue,
                                          )
                                        ],
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
                                                    SeparateLabelMapKey()
                                                        .price],
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
                                  ),

                                  //区切り線
                                  const Divider(
                                    thickness: 1,
                                    height: 1,
                                    color: MyColors.dimGray,
                                  )
                                ],
                              ),

                              //タイルを横にスライドした時の処理
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm"), // ダイアログのタイトル
                                      content: Text(
                                          "Are you sure you wish to delete this item?"), // ダイアログのメッセージ
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(context)
                                              .pop(false), // キャンセルボタンを押したときの処理
                                          child: Text("CANCEL"),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context)
                                              .pop(true), // 削除ボタンを押したときの処理
                                          child: Text("DELETE"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },

                              //ダイアログでOKを押したら処理
                              onDismissed: (direction) {
                                final record = TBL001Record(
                                  id: item[TBL001RecordKey().id],
                                  category:
                                      item[TBL001RecordKey().paymentCategoryId],
                                  price: item[TBL001RecordKey().price],
                                  memo: item[TBL001RecordKey().memo],
                                  date: item[TBL001RecordKey().date],
                                );
                                record.delete();
                                print('削除されました id:${item[TBL001RecordKey().id]}'
                                    'category:${item[TBL001RecordKey().paymentCategoryId]}'
                                    'price:${item[TBL001RecordKey().price]}'
                                    'memo:${item[TBL001RecordKey().memo]}'
                                    '${item[TBL001RecordKey().date]}年');
                              },
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
            children = Container(child:Text('データが見つかりません',style: TextStyle(color: MyColors.white),));
          } else {
            children = Container(child:Text('データが見つかりません',style: TextStyle(color: MyColors.white),));
          }

          return children;
        });
  }

  void _scrollToItem(
      DateTime dt, List keysList, AutoScrollController controller) async {
    final specificItem = dt;
    final index = keysList.indexOf(specificItem);
    await controller.scrollToIndex(
      index,
      // preferPosition: AutoScrollPosition.begin,
    );
    await controller.highlight(index);
  }

  descendingOrderSort(List<Map> itemsInADay) {
    //sortはvoid関数
    itemsInADay.sort(
        ((a, b) => b[TBL001RecordKey().id].compareTo(a[TBL001RecordKey().id])));
    final sorted = itemsInADay;
    return sorted;
  }
}
