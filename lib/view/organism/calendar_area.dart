import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kakeibo/view_model/provider/active_datetime.dart';
import 'package:kakeibo/view_model/provider/update_DB_count.dart';

import 'package:kakeibo/view_model/calendar_builder.dart';
import 'package:kakeibo/view_model/reference_day_impl.dart';

import 'package:kakeibo/view/molecule/calendar_date_box.dart';
import 'package:kakeibo/view/molecule/calendar_month_display.dart';
import 'package:kakeibo/view/atom/calendar_header.dart';
import 'package:kakeibo/view/atom/next_arrow_button.dart';
import 'package:kakeibo/view/atom/previous_arrow_button.dart';

class CalendarArea extends ConsumerWidget {
  CalendarArea({super.key});

  // pageViewのコントローラ
  // 閾値：[0,1000] 初期値：500
  final int initialCenter = 500;
  final pageController = PageController(
    initialPage: 500,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    print('calendar_area is built');
//状態管理---------------------------------------------------------------------------------------

    //databaseに操作がされた場合にカウントアップされるprovider
    ref.watch(updateDBCountNotifierProvider);

    // dayが変わった時だけ再描画する
    final activeDay = ref.watch(
        activeDatetimeNotifierProvider.select((DateTime value) => value.day));

//----------------------------------------------------------------------------------------------

//描写-------------------------------------------------------------------------------------------
    return Container(
      height: 302,
      child: PageView.builder(
        controller: pageController,
        itemBuilder: (context, index) {
          // データ取得------------------------------------------------------
          // index=500は常にその日の月で設定
          final todayDateTime = DateTime.now();

          // そのページが現在の月のページ(index = 500)からどれだけ離れているか
          int dateDiff = index - initialCenter;

          // index=500 からどれだけ離れているかのdatediffを月に足し、日にはactiveDateTimeのdayを代入
          final thisIndexDisplayDate = DateTime(todayDateTime.year,
              todayDateTime.month + dateDiff, activeDay);

          // 表示する年月のラベルを取得
          final calendarMonthDisplayLabel = getYYDDLabel(thisIndexDisplayDate);

          // 表示月のデータを取得
          final calendarData = CalendarBuilder().build(thisIndexDisplayDate);

          // データ取得終わり------------------------------------------------------

          return Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //左矢印ボタン、押すと前の月に移動
                PreviousArrowButton(function: () async{
                  await pageController.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic);
                  print(pageController.page);
                }),
                CalendarMonthDisplay(label: calendarMonthDisplayLabel),

                //右矢印ボタン、押すと次の月に移動
                NextArrowButton(function: () async{
                  await pageController.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic);
                  print(pageController.page);
                }),
              ],
            ),
            const CalendarHeader(),
            ...List.generate(
                calendarData.length,
                (weekIndex) =>
                    _weekRow(ref, weekIndex, calendarData, thisIndexDisplayDate)),
          ]);
        },
        onPageChanged: (page) {
          // pageは現在ページ
          // pageController.page!は次ページに向かっている時の値なので、double型
          var isMovingToNext = page > pageController.page!;

          final notifier = ref.read(activeDatetimeNotifierProvider.notifier);

          print(page.toString());
          print(pageController.page!.toString());
          
          if (isMovingToNext == true) {
            notifier.updateToNextMonth();
            print('called updateToNextMonth()');
          } else if (isMovingToNext == false) {
            notifier.updateToPreviousMonth();
            print('called updateToPreviousMonth()');
          }
        },
      ),
    );
  }
}

Row _weekRow(
    WidgetRef ref,
    int weekIndex,
    List<List<Map<String, dynamic>>> dateInformationList,
    DateTime displayDate) {
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

        if (day == 1) {
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
                  onTap: isTapable
                      ? () {
                          final notifier =
                              ref.read(activeDatetimeNotifierProvider.notifier);
                          notifier.updateState(DateTime(year, month, day));
                          print('date = $label がタップされました。');
                          print(
                              '現在のactiveDateTimeは${ref.read(activeDatetimeNotifierProvider)}');
                        }
                      : null,
                  child: displayDate == DateTime(year, month, day)
                      ? activeDateBox(weekday, label, label2)
                      : isTapable
                          ? normalDateBox(weekday, label, label2)
                          : vacantDateBox(weekday, label, label2));
            }));
      }));
}

String gettermmdd(List<List<Map<String, dynamic>>> dateInformationList,
    int weekIndex, int dayIndex) {
  final month = dateInformationList[weekIndex][dayIndex]['month'].toString();
  final day = dateInformationList[weekIndex][dayIndex]['day'].toString();
  return '$month月$day日';
}
