import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakeibo/constant/colors.dart';

import 'package:kakeibo/view/test_all_row_get_button.dart';
import 'package:kakeibo/view/organism/price_input_field.dart';
import 'package:kakeibo/view/organism/memo_input_field.dart';
import 'package:kakeibo/view/organism/category_area.dart';
import 'package:kakeibo/view/organism/torok_selected_segment.dart';
import 'package:kakeibo/view_model/provider/selected_segment_status.dart';
import 'package:kakeibo/view_model/provider/home_datetime/torok_button.dart';
import 'package:kakeibo/view_model/provider/is_registerable.dart';
import 'package:kakeibo/view/organism/date_input_field.dart';
import 'package:kakeibo/view_model/provider/category.dart';
import 'package:kakeibo/view_model/provider/tbl001_state/tbl001_state.dart';

class Torok extends StatefulHookConsumerWidget {
  const Torok({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TorokState();
}

class _TorokState extends ConsumerState<Torok> {
  goHome(BuildContext context) {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    //状態管理---------------------------------------------------------------------------------------

    final selectedSegmentedStatus =
        ref.watch(selectedSegmentStatusNotifierProvider);

    final String label;
    if (selectedSegmentedStatus == SelectedEnum.sisyt) {
      label = '支出';
    } else if (selectedSegmentedStatus == SelectedEnum.syunyu) {
      label = '収入';
    } else {
      label = '';
    }

    //listenもしくはwatchし続けやんとstateが勝手にdisposeされる
    //なのでlistenしている
    //watchやといちいちリビルドされるのでlisten
    ref.listen(
      tBL001RecordNotifierProvider,
      (oldState, newState) {
        //なんもしやん
      },
    );

    ref.listen(
      isRegisterableNotifierProvider,
      (oldState, newState) {
        //なんもしやん
      },
    );

    ref.listen(
      categoryNotifierProvider,
      (oldState, newState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('カテゴリーがxxに変更されました')));
      },
    );

    //----------------------------------------------------------------------------------------------
    //レイアウト------------------------------------------------------------------------------------

    return Scaffold(
      // backgroundColor: MyColors.richBlack,
      appBar: AppBar(
        //ヘッダー右のアイコンボタン
        actions: [
          IconButton(
            onPressed: () {
              //登録可非の状態管理
              final isRegisterableNotifier =
                  ref.read(isRegisterableNotifierProvider.notifier);

              //tbl001recordの金額を取得
              final tbl001StateProvider =
                  ref.read(tBL001RecordNotifierProvider);
              final price = tbl001StateProvider.price;

              //金額分岐でisRegisterableの更新とメッセージ定義
              if (price <= 0) {
                isRegisterableNotifier.updateState(false);
              } else if (price >= 1888888) {
                isRegisterableNotifier.updateState(false);
              } else {
                isRegisterableNotifier.updateState(true);
              }

              final isRegisterableProvider =
                  ref.read(isRegisterableNotifierProvider);

              if (isRegisterableProvider == true) {
                //挿入
                final notifier =
                    ref.read(tBL001RecordNotifierProvider.notifier);
                notifier.insertToTable();
                Navigator.of(context).pop();
                //スナックバーやとfloatingactionbuttonが浮いてしまうので他の方法を考える
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                    content: Text('登録が完了しました'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ));
              } else if (isRegisterableProvider == false) {
                //エラーハンドル
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                      content: Text('正しく入力してください'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2)));
                // showAdaptiveDialog(
                //   context: context,
                //   builder: (dialogContext) {
                //     return AlertDialog.adaptive(
                //       title: const Text("エラーテキスト1"),
                //       content: Text('エラーテキスト2'),
                //       actions: [
                //         TextButton(
                //           child: const Text("OK"),
                //           onPressed: () {
                //             Navigator.of(dialogContext).pop();
                //           },
                //         ),
                //       ],
                //     );
                //   },
                // );
              }
            },
            icon: const Icon(
              Icons.done_rounded,
              color: MyColors.white,
            ),
          ),
        ],

        //ヘッダーの左ボタン
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.close_rounded,
            color: MyColors.white,
          ),
        ),

        backgroundColor: MyColors.jet,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        title: const SizedBox(
          child: Text('Torok'),
        ),
      ),

      backgroundColor: MyColors.richBlack,
      //body
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 5),
      
              // CupertinoSlidingSegmentedControl<SelectedEnum>(
              //   backgroundColor: MyColors.jet,
              //   thumbColor: MyColors.dimGray,
              //   // This represents the currently selected segmented control.
              //   groupValue: selectedSegmentedStatus,
              //   // Callback that sets the selected segmented control.
              //   onValueChanged: (SelectedEnum? value) {
              //     if (value != null) {
              //       final notifier =
              //           ref.read(selectedSegmentStatusNotifierProvider.notifier);
              //       notifier.updateState(value);
              //     }
              //   },
              //   children: const <SelectedEnum, Widget>{
              //     SelectedEnum.sisyt: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 20),
              //       child: Text(
              //         '支出',
              //         style: TextStyle(color: CupertinoColors.white),
              //       ),
              //     ),
              //     SelectedEnum.syunyu: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 20),
              //       child: Text(
              //         '収入',
              //         style: TextStyle(color: CupertinoColors.white),
              //       ),
              //     ),
              //   },
              // ),
              const TorokSelectedSegment(),
              const SizedBox(height: 5),
              PriceInputField(
                label: label,
              ),
              const SizedBox(height: 4.5),
              const MemoInputField(),
              const SizedBox(height: 4.5),
              const DateDisplay(),
              const SizedBox(height: 4.5),
              const CategoryArea(),
            ],
          ),
        ),
      ),
    );
  }
}
