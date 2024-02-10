import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/repository/tbl001_record.dart';

import 'package:kakeibo/view/test_all_row_get_button.dart';
import 'package:kakeibo/view/organism/price_input_field.dart';
import 'package:kakeibo/view/organism/memo_input_field.dart';
import 'package:kakeibo/view/organism/category_area.dart';
import 'package:kakeibo/view/organism/torok_selected_segment.dart';
import 'package:kakeibo/view_model/provider/selected_segment_status.dart';
import 'package:kakeibo/view_model/provider/is_registerable.dart';
import 'package:kakeibo/view_model/provider/update_DB_count.dart';

import 'package:kakeibo/view/organism/date_input_field.dart';
import 'package:kakeibo/view_model/provider/category.dart';
import 'package:kakeibo/view_model/provider/tbl001_state/tbl001_state.dart';

class Torok extends ConsumerStatefulWidget {
  const Torok(
      {this.screenMode,
      this.tBL001Record,
      super.key});

  //0:登録モード、1:編集モード
  final int? screenMode;
  final TBL001Record? tBL001Record;
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

    //前画面からレコードを受け取っていればそれを設定する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.tBL001Record != null) {
      final notifier = ref.read(tBL001RecordNotifierProvider.notifier);
      notifier.setData(widget.tBL001Record!);
      }
    });

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
      backgroundColor: MyColors.richBlack,

      appBar: AppBar(
        //ヘッダー右のアイコンボタン
        actions: [
          IconButton(
            
            icon: const Icon(
              //完了チェックマーク
              Icons.done_rounded,
              color: MyColors.white,
            ),

            onPressed: () {
              //登録可非の状態管理
              final isRegisterableNotifier =
                  ref.read(isRegisterableNotifierProvider.notifier);

              //tbl001recordの金額を取得
              final tbl001StateProvider =
                  ref.read(tBL001RecordNotifierProvider);
              final price = tbl001StateProvider.price;

              //エラーチェック
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

              //登録できるなら
              if (isRegisterableProvider == true) {
                //挿入
                final notifier =
                    ref.read(tBL001RecordNotifierProvider.notifier);

                //登録モード
                if (widget.screenMode == 0) {
                  notifier.insert();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: Text('登録が完了しました'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                } 
                //編集モード
                else if (widget.screenMode == 1) {
                  notifier.update();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: Text('変更が完了しました'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                }
                //DB更新のnotifier
                //DBが更新されたことをグローバルなproviderに反映
                final notifier2 =
                    ref.read(updateDBCountNotifierProvider.notifier);
                notifier2.incrementState();
              } 
              //登録できないなら
              else if (isRegisterableProvider == false) {
                //エラーハンドル
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                      content: Text('正しく入力してください'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2)));
              }
            },
          ),
        ],

        //ヘッダーの左ボタン
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            //バッテン
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
          child: Text('登録画面'),
        ),
      ),

      //body
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 5),
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
