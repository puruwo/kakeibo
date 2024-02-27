import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/view_model/provider/torok_state/torok_state.dart';

class DateDisplay extends ConsumerWidget {
  const DateDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(torokRecordNotifierProvider);

    return GestureDetector(
      onTap: () async {
        //providerを取得
        final provider = ref.read(torokRecordNotifierProvider);
        //現在の選択日付を取得
        final dt = DateTime.parse(provider.date);


        //カレンダーピッカーで日付を選択し取得
        final DateTime? picked = await showDatePicker(
          context: context,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: dt, // 最初に表示する日付
          firstDate: DateTime(2020), // 選択できる日付の最小値
          lastDate: DateTime(2025), // 選択できる日付の最大値
        );

        //notifierを取得
        final notifier = ref.read(torokRecordNotifierProvider.notifier);
        //nullチェックせなあかん
        if (picked != null) {
          notifier.updateDate(picked);
        } else {
          print(e);
        }
      },

      child: Container(
        decoration: const BoxDecoration(
          color: MyColors.jet,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        width: 332,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 11.5),
              child: Text(
                '日付',
                textAlign: TextAlign.right,
                style: TextStyle(color: MyColors.white, fontSize: 17),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 11.5),
              child: Text(
                '${provider.date.substring(0,4)}年${int.parse(provider.date.substring(4,6)).toString()}月${int.parse(provider.date.substring(6,8)).toString()}日',
                textAlign: TextAlign.right,
                style: const TextStyle(color: MyColors.white, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
