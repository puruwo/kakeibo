import 'package:kakeibo/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:kakeibo/repository/tbl001_record.dart';
import 'package:kakeibo/view_model/provider/tbl001_state/tbl001_state.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:collection';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';

import 'package:kakeibo/view/page/torok.dart';

import 'package:kakeibo/view_model/provider/active_datetime.dart';
import 'package:kakeibo/view_model/provider/update_DB_count.dart';

import 'package:kakeibo/view_model/reference_day_impl.dart';

import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tbl001_impl.dart';
import 'package:kakeibo/model/tableNameKey.dart';

class ExpenceHistoryArea extends HookConsumerWidget {
  const ExpenceHistoryArea({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
//状態管理---------------------------------------------------------------------------------------

    //databaseに操作がされた場合にカウントアップされるprovider
    ref.watch(updateDBCountNotifierProvider);

    final activeDateTime = ref.watch(activeDatetimeNotifierProvider);

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
            //Mapのキーで上から降順に並び替える
            //型指定してやらんとエラーになる、Object型で判定されるため
            final sortedGroupedMap = SplayTreeMap.from(groupedMap,
                (DateTime key1, DateTime key2) => key2.compareTo(key1));

            return SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: sortedGroupedMap.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime dateTime = sortedGroupedMap.keys.elementAt(index);
                  List itemsInADay = sortedGroupedMap[dateTime]!;

                  final stringDate =
                      '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
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
                          return ListTile(
                            onTap: () {
                              // final notifier = ref
                              //     .read(tBL001RecordNotifierProvider.notifier);
                              // notifier.setData(TBL001Record(
                              //   year: item[SeparateLabelMapKey().year],
                              //   month: item[SeparateLabelMapKey().month],
                              //   day: item[SeparateLabelMapKey().day],
                              //   id: item[SeparateLabelMapKey().id],
                              //   price: item[SeparateLabelMapKey().price],
                              //   memo: item[SeparateLabelMapKey().memo],
                              //   category: item[SeparateLabelMapKey().category]
                              // ));

                              showCupertinoModalBottomSheet(
                                //sccafoldの上に出すか
                                useRootNavigator: true,
                                context: context,
                                builder: (_) => Torok(
                                  tBL001Record: TBL001Record(
                                      year: item[SeparateLabelMapKey().year],
                                      month: item[SeparateLabelMapKey().month],
                                      day: item[SeparateLabelMapKey().day],
                                      id: item[SeparateLabelMapKey().id],
                                      price: item[SeparateLabelMapKey().price],
                                      memo: item[SeparateLabelMapKey().memo],
                                      category:
                                          item[SeparateLabelMapKey().category]),
                                  screenMode: 1,
                                ),
                                isDismissible: true,
                              );
                            },
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
