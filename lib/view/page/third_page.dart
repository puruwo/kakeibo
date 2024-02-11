import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kakeibo/constant/colors.dart';

import 'package:kakeibo/view/test_all_row_get_button.dart';
import 'package:kakeibo/view/organism/price_input_field.dart';
import 'package:kakeibo/view/organism/memo_input_field.dart';
import 'package:kakeibo/view/organism/category_area.dart';
import 'package:kakeibo/view/organism/date_input_field.dart';

import 'package:kakeibo/view_model/provider/tbl001_state/tbl001_state.dart';

class Third extends HookConsumerWidget {
  const Third({super.key});

  goHome(BuildContext context) {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //状態管理---------------------------------------------------------------------------------------

    //listenもしくはwatchし続けやんとstateが勝手にdisposeされる
    //なのでlistenしている
    //watchやといちいちリビルドされるのでlisten
    ref.listen(
      tBL001RecordNotifierProvider,
      (oldState, newState) {
        //なんもしやん
      },
    );

    //----------------------------------------------------------------------------------------------
    //各種パーツ--------------------------------------------------------------------------------------

    //--------------------------------------------------------------------------------------------
    //レイアウト------------------------------------------------------------------------------------

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.jet,
        title: const SizedBox(
          child: Text('kakeibo'),
        ),
      ),
      body: const Center(
        child: Column(
          children: [
            Text('This is third_page')
          ],
        ),
      ),
    );
  }
}
