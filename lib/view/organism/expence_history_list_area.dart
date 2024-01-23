import 'package:kakeibo/constant/colors.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';

import 'package:kakeibo/view/molecule/expence_history_list_tile.dart';
import 'package:kakeibo/view/molecule/group_separator.dart';

import 'package:kakeibo/view_model/provider/active_datetime.dart';
import 'package:kakeibo/view_model/reference_day_impl.dart';

import 'package:kakeibo/model/tbl001_impl.dart';
import 'package:kakeibo/model/tableNameKey.dart';

class ExpenceHistoryArea extends HookConsumerWidget {
  const ExpenceHistoryArea({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // //スクロールビューコントローラーの宣言
    // final controller = GroupedItemScrollController();

//状態管理---------------------------------------------------------------------------------------

    final activeDateTime = ref.watch(activeDatetimeNotifierProvider);

    //使えそうにない、、、、TT
    //'0000年00月'の形式のラベルを取得
    // final stringDate = '2023年11月17日';
    // final stringDate = '${activeDateTime.year}年${activeDateTime.month}月${activeDateTime.day}日';

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
                snapshot.data!.groupListsBy<DateTime>((e) => e['dateTime']);
            //Mapのキーで昇順に並び替える
            //型指定してやらんとエラーになる、Object型で判定されるため
            final sortedGroupedMap = SplayTreeMap.from(groupedMap, (DateTime key1,DateTime key2) => key1.compareTo(key2));

            return SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: sortedGroupedMap.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime dateTime = sortedGroupedMap.keys.elementAt(index);
                  List itemsInADay = sortedGroupedMap[dateTime]!;

                  final stringDate = '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
                  return Column(
                    children: [
                      Text(stringDate,
                          style: const TextStyle(
                              color: MyColors.white,
                              fontWeight: FontWeight.bold)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: itemsInADay.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = itemsInADay[index];
                          // Return a widget representing the item
                          return ListTile(
                            title: Row(
                              children: [
                                Text(
                                  item['_id'].toString(),
                                  style: const TextStyle(color: MyColors.white),
                                ),
                                const Text('：',
                                    style: TextStyle(color: MyColors.white)),
                                Text(
                                  item['price'].toString(),
                                  style: const TextStyle(color: MyColors.white),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            children = Container();
          } else {
            children = Container();
          }

          return children;
        });
  }
}
