import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/repository/torok_record/torok_record.dart';

import 'package:kakeibo/view/organism/price_input_field.dart';
import 'package:kakeibo/view/organism/memo_input_field.dart';
import 'package:kakeibo/view/organism/category_area.dart';
import 'package:kakeibo/view/organism/torok_selected_segment.dart';
import 'package:kakeibo/view_model/provider/torok_state/selected_segment_status.dart';
import 'package:kakeibo/view_model/provider/torok_state/is_registerable.dart';
import 'package:kakeibo/view_model/provider/torok_state/when_open.dart';
import 'package:kakeibo/view_model/provider/update_DB_count.dart';

import 'package:kakeibo/view/organism/date_input_field.dart';
import 'package:kakeibo/view_model/provider/torok_state/torok_state.dart';
import 'package:kakeibo/view_model/provider/tbl002_state/tbl002_state.dart';

class Torok extends ConsumerStatefulWidget {
  const Torok({this.screenMode = 0, this.torokRecord, super.key});

  //0:登録モード、1:編集モード
  final int screenMode;
  final TorokRecord? torokRecord;
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

    final whenOpenprovider = ref.watch(whenOpenNotifierProvider);

    //ビルド完了時の操作
    //前画面からレコードを受け取っていればそれを設定する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Torokを受け取ってる時 && リビルドじゃない時
      //データをセットしてwhenOpenフラグをfalseに設定する
      if (widget.torokRecord != null && whenOpenprovider == true) {
        final notifier = ref.read(torokRecordNotifierProvider.notifier);
        notifier.setData(widget.torokRecord!);
      }
      final whenOpenNotifier = ref.read(whenOpenNotifierProvider.notifier);
        whenOpenNotifier.updateToOpenedState();
    });

    //支出か収入かの切り替えは登録時のみ可能
    //編集モードでは他のレコードに影響を与える可能性があるため実装しない
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
        torokRecordNotifierProvider,
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

              //torokrecordの金額を取得
              if (selectedSegmentedStatus == SelectedEnum.sisyt) {
                final torokStateProvider =
                    ref.read(torokRecordNotifierProvider);
                final price = torokStateProvider.price;

                //エラーチェック
                //金額分岐でisRegisterableの更新とメッセージ定義
                if (price <= 0) {
                  isRegisterableNotifier.updateState(false);
                } else if (price >= 1888888) {
                  isRegisterableNotifier.updateState(false);
                } else {
                  isRegisterableNotifier.updateState(true);
                }
              } else if (selectedSegmentedStatus == SelectedEnum.syunyu) {
                isRegisterableNotifier.updateState(true);
              }

              final isRegisterableProvider =
                  ref.read(isRegisterableNotifierProvider);
              //登録できるなら
              if (isRegisterableProvider == true) {
                //挿入
                final notifier = ref.read(torokRecordNotifierProvider.notifier);

                //登録モード
                if (widget.screenMode == 0) {
                  if(selectedSegmentedStatus == SelectedEnum.sisyt){
                    notifier.setToTBL001().insert();
                  }else if(selectedSegmentedStatus == SelectedEnum.syunyu){
                    notifier.setToTBL002().insert();
                  }
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
                  if(selectedSegmentedStatus == SelectedEnum.sisyt){
                    notifier.setToTBL001().update();
                  }else if(selectedSegmentedStatus == SelectedEnum.syunyu){
                    notifier.setToTBL002().update();
                  }
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
              //登録モードなら切り替えを出す
              //編集モードなら出せない
              widget.screenMode != 1
                  ? const TorokSelectedSegment()
                  : const SizedBox(
                      height: 0,
                    ),
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
