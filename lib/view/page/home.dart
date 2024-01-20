import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/view/page/torok.dart';
import 'package:kakeibo/view/organism/calendar_area.dart';
import 'package:kakeibo/view/organism/expence_history_list_area.dart';
import 'package:kakeibo/view_model/provider/initial_open.dart';

class Home extends ConsumerWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return const Scaffold(
      backgroundColor: MyColors.richBlack,
      body: Center(
        child: Column(
          children: [
            Center(
                child: Column(children: [
              CalendarArea(),
              ExpenceHistoryArea(),
            ])),
            // testButton2
          ],
        ),
      ),
    );
  }
}
