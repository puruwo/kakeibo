import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kakeibo/view_model/provider/active_datetime.dart';
import 'package:kakeibo/view_model/calendar_builder.dart';
import 'package:kakeibo/view_model/reference_day_impl.dart';

import 'package:kakeibo/view/molecule/calendar_date_box.dart';
import 'package:kakeibo/view/molecule/calendar_month_display.dart';
import 'package:kakeibo/view/atom/calendar_header.dart';
import 'package:kakeibo/view/atom/next_arrow_button.dart';
import 'package:kakeibo/view/atom/previous_arrow_button.dart';

class CalendarArea extends HookConsumerWidget {
  const CalendarArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
//状態管理---------------------------------------------------------------------------------------

    final activeDateTime = ref.watch(activeDatetimeNotifierProvider);

//----------------------------------------------------------------------------------------------
//データ取得--------------------------------------------------------------------------------------

    //表示する年月のラベルを取得
    final calendarMonthDisplayLabel = getYYDDLabel(activeDateTime);

    // final calendarData = CalendarBuilder().build(DateTime(2023,1,25));
    final calendarData = CalendarBuilder().build(activeDateTime);

//描写-------------------------------------------------------------------------------------------
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //左矢印ボタン、押すと前の月に移動
          PreviousArrowButton(function: () {
            final notifier = ref.read(activeDatetimeNotifierProvider.notifier);
            notifier.updateToPreviousReferenceDay();
          }),
          CalendarMonthDisplay(label: calendarMonthDisplayLabel),

          //右矢印ボタン、押すと次の月に移動
          NextArrowButton(function: () {
            final notifier = ref.read(activeDatetimeNotifierProvider.notifier);
            notifier.updateToNextReferenceDay();
          }),
        ],
      ),
      const CalendarHeader(),
      ...List.generate(
          calendarData.length,
          (weekIndex) => _weekRow(
              ref, weekIndex, calendarData, activeDateTime)),
    ]);
  }
}

Row _weekRow(
    WidgetRef ref,
    int weekIndex,
    List<List<Map<String, dynamic>>> dateInformationList,
    DateTime activeDateTime) {
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

        String mmdd = gettermmdd(dateInformationList, weekIndex, dayIndex);

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
                  child: activeDateTime == DateTime(year, month, day)
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
