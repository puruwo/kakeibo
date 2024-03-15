import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakeibo/constant/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';

import 'package:kakeibo/view_model/provider/active_datetime.dart';
import 'package:kakeibo/view_model/provider/update_DB_count.dart';

import 'package:kakeibo/view_model/calendar_builder.dart';
import 'package:kakeibo/view_model/reference_day_impl.dart';

import 'package:kakeibo/repository/torok_record/torok_record.dart';

import 'package:kakeibo/view/molecule/calendar_date_box.dart';
import 'package:kakeibo/view/molecule/calendar_month_display.dart';
import 'package:kakeibo/view/atom/calendar_header.dart';
import 'package:kakeibo/view/atom/next_arrow_button.dart';
import 'package:kakeibo/view/atom/previous_arrow_button.dart';

import 'package:kakeibo/view/page/torok.dart';

class CalendarArea extends ConsumerWidget {
  CalendarArea({super.key, required this.pageController});

  // pageViewのコントローラ
  // 閾値：[0,1000] 初期値：500
  final int initialCenter = 500;
  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('calendar_area is built');
//状態管理---------------------------------------------------------------------------------------

    //databaseに操作がされた場合にカウントアップされるprovider
    ref.watch(updateDBCountNotifierProvider);

    // dayが変わった時だけ再描画する
    final activeDay = ref.watch(
        activeDatetimeNotifierProvider.select((DateTime value) => value.day));

    // ビルドが終わってからじゃないとコントローラが紐づいてないので怒られる
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DateTime activedt = ref.read(activeDatetimeNotifierProvider);
      setPageControllerIndexFromActiveDt(activedt);
    });

//----------------------------------------------------------------------------------------------

//描写-------------------------------------------------------------------------------------------
    return Container(
      decoration: BoxDecoration(
          color: MyColors.quarternarySystemfill,
          borderRadius: BorderRadius.circular(18)),
      width: 346,
      height: 302,
      child: PageView.builder(
        controller: pageController,
        itemBuilder: (context, index) {
          // データ取得------------------------------------------------------

          // そのindexで表示する日付のゲッター
          final thisIndexDisplayDateTime =
              getThisIndexDisplayDt(index, activeDay);

          // 表示月のデータを取得
          final calendarData =
              CalendarBuilder().build(thisIndexDisplayDateTime);

          // その月が何週間表示されるか
          final weekNumber = calendarData.length;

          final boxHeight = (weekNumber == 5)
              ?
              // 5週間表示なら高さは60
              54.0
              // 6週間表示なら高さは50
              : 45.0;

          // データ取得終わり------------------------------------------------------

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // カレンダーヘッダー
              const CalendarHeader(),

              // 区切り線
              const Divider(
                // ウィジェット自体の高さ
                height: 0,
                // 線の太さ
                thickness: 0.25,
                indent: 0,
                endIndent: 0,
                color: MyColors.separater,
              ),

              // カレンダー中身
              ...List.generate(calendarData.length, (weekIndex) {
                return Column(
                  children: [
                    _weekRow(ref, weekIndex, calendarData,
                        thisIndexDisplayDateTime, boxHeight),
                    // 区切り線
                    const Divider(
                      height: 0,
                      thickness: 0.25,
                      indent: 0,
                      endIndent: 0,
                      color: MyColors.separater,
                    ),
                  ],
                );
              }),
            ],
          );
        },
        onPageChanged: (page) {
          // pageは現在ページ
          // pageController.page!は次ページに向かっている時の値なので、double型
          int movingDirection;

          if (page > pageController.page!) {
            movingDirection = 1;
          } else if (page < pageController.page!) {
            movingDirection = -1;
          } else {
            movingDirection = 0;
          }

          final notifier = ref.read(activeDatetimeNotifierProvider.notifier);

          print(page.toString());
          print(pageController.page!.toString());

          if (movingDirection == 1) {
            notifier.updateToNextMonth();
            print('called updateToNextMonth()');
          } else if (movingDirection == -1) {
            notifier.updateToPreviousMonth();
            print('called updateToPreviousMonth()');
          } else if (movingDirection == 0) {
            print('page isn\'t moving');
          }
        },
      ),
    );
  }

  void setPageControllerIndexFromActiveDt(DateTime activedt) {
    // activeDtから基準日を取得
    final activeDtReferenceDt = getReferenceDay(activedt);

    // 現在の日付の基準日を取得
    DateTime nowDt = DateTime.now();
    final nowDtReferenceDt = getReferenceDay(nowDt);

    // pageViewはindex=500がDateTime.now()で設定されるので
    // 月の差分をPageControllerに反映
    final monthDiff =
        (activeDtReferenceDt.year * 12 + activeDtReferenceDt.month) -
            (nowDtReferenceDt.year * 12 + nowDtReferenceDt.month);

    pageController.jumpToPage((initialCenter + monthDiff));
  }

  DateTime getThisIndexDisplayDt(int index, int activeDay) {
    // そのページが現在の月のページ(index = 500)からどれだけ離れているか
    int monthDiff = index - initialCenter;

    DateTime nowDt = DateTime.now();
    final nowDtReferenceDay = getReferenceDay(nowDt);

    // activeDayが基準日と同じ月でなければ(次の月ならば)現在の月のページとずれが出るので1足す必要がある
    final month =
        activeDay >= 25 ? nowDtReferenceDay.month : nowDtReferenceDay.month + 1;
    return DateTime(nowDtReferenceDay.year, month + monthDiff, activeDay);
  }
}

Row _weekRow(
    WidgetRef ref,
    int weekIndex,
    List<List<Map<String, dynamic>>> dateInformationList,
    DateTime displayDate,
    double boxHeight) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (dayIndex) {
        bool isTapable = dateInformationList[weekIndex][dayIndex]['isTapable'];
        int year = dateInformationList[weekIndex][dayIndex]['year'];
        int month = dateInformationList[weekIndex][dayIndex]['month'];
        int day = dateInformationList[weekIndex][dayIndex]['day'];

        Future<int> buff = dateInformationList[weekIndex][dayIndex]['priceSum'];

        String label;
        String label2;

        if (day == 1 || day == 25) {
          label = '$month/$day';
        } else {
          label = '$day';
        }

        int weekday = dayIndex + 1;

        return FutureBuilder(
            future: buff,
            builder: ((context, snapshot) {
              if (snapshot.data == 0) {
                label2 = '';
              } else {
                if (snapshot.data == null || snapshot.data! > 1888888) {
                  label2 = '';
                } else if (snapshot.data! <= 99999) {
                  label2 = '¥-${snapshot.data.toString()}';
                } else {
                  label2 = snapshot.data.toString();
                }
              }
              return InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: isTapable
                      ? () {
                          final provider =
                              ref.read(activeDatetimeNotifierProvider);

                          // タップした日付が状態と違っていたら状態を更新
                          if (DateFormat('yyyyMMdd').format(provider) !=
                              DateFormat('yyyyMMdd')
                                  .format(DateTime(year, month, day))) {
                            final notifier = ref
                                .read(activeDatetimeNotifierProvider.notifier);
                            notifier.updateState(DateTime(year, month, day));
                          }
                          // タップした日付が状態と同じならタップした日付を持ったTorok画面を出す
                          else if (DateFormat('yyyyMMdd').format(provider) ==
                              DateFormat('yyyyMMdd')
                                  .format(DateTime(year, month, day))) {
                            showCupertinoModalBottomSheet(
                                //sccafoldの上に出すか
                                useRootNavigator: true,
                                //縁タップで閉じる
                                isDismissible: true,
                                context: context,
                                builder: (_) => Torok.origin(
                                      torokRecord: TorokRecord(
                                          date: DateFormat('yyyyMMdd').format(
                                              DateTime(year, month, day))),
                                      screenMode: 0,
                                    ));
                          }
                        }
                      : null,

                  // ロングプレスでも選択日付を持った登録画面を出す
                  onLongPress: () => isTapable
                      ? showCupertinoModalBottomSheet(
                          //sccafoldの上に出すか
                          useRootNavigator: true,
                          //縁タップで閉じる
                          isDismissible: true,
                          context: context,
                          builder: (_) => Torok.origin(
                                torokRecord: TorokRecord(
                                    date: DateFormat('yyyyMMdd')
                                        .format(DateTime(year, month, day))),
                                screenMode: 0,
                              ))
                      : null,
                  child: displayDate == DateTime(year, month, day)
                      ? activeDateBox(weekday, label, label2, boxHeight)
                      : isTapable
                          ? normalDateBox(weekday, label, label2, boxHeight)
                          : vacantDateBox(weekday, label, label2, boxHeight));
            }));
      }));
}

String gettermmdd(List<List<Map<String, dynamic>>> dateInformationList,
    int weekIndex, int dayIndex) {
  final month = dateInformationList[weekIndex][dayIndex]['month'].toString();
  final day = dateInformationList[weekIndex][dayIndex]['day'].toString();
  return '$month月$day日';
}
