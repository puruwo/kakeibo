import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/repository/torok_record/torok_record.dart';
import 'package:flutter/services.dart';

import 'package:kakeibo/view/organism/input_field_back.dart';
import 'package:kakeibo/view/organism/category_area.dart';
import 'package:kakeibo/view/organism/torok_selected_segment.dart';
import 'package:kakeibo/view_model/provider/torok_state/selected_segment_status.dart';
import 'package:kakeibo/view_model/provider/torok_state/is_registerable.dart';
import 'package:kakeibo/view_model/provider/update_DB_count.dart';

import 'package:kakeibo/view/organism/date_input_field.dart';
import 'package:kakeibo/view_model/provider/torok_state/torok_state.dart';

class Torok extends ConsumerStatefulWidget {
  //0:登録モード、1:編集モード
  final int screenMode;
  final TorokRecord torokRecord;

  Torok({this.screenMode = 0, super.key})
      : torokRecord = TorokRecord(date: DateTime.now().toString());

  const Torok.origin({this.screenMode = 0, required this.torokRecord, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TorokState();
}

class _TorokState extends ConsumerState<Torok> {
  late TextEditingController _priceInputController;
  late TextEditingController _memoInputController;
  late DateTime _dateController;

  @override
  void initState() {
    // 初期値が0なら空文字を入れる
    final initialPriceData = widget.torokRecord.price == 0
        ? ''
        : widget.torokRecord.price.toString();

    _priceInputController = TextEditingController(text: initialPriceData);
    _memoInputController = TextEditingController(text: widget.torokRecord.memo);
    _dateController = DateTime.parse(widget.torokRecord.date);
    super.initState();
  }

  @override
  void dispose() {
    _priceInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //状態管理---------------------------------------------------------------------------------------

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
      backgroundColor: MyColors.eerieBlack,

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
                final price = int.parse(_priceInputController.text);

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
                final provider = ref.read(torokRecordNotifierProvider);
                final selectedCategory = provider.category;

                notifier.setData(TorokRecord(
                    id: widget.torokRecord.id,
                    price: int.parse(_priceInputController.text),
                    date: DateFormat('yyyyMMdd').format(_dateController),
                    memo: _memoInputController.text,
                    category: selectedCategory));

                //登録モード
                if (widget.screenMode == 0) {
                  if (selectedSegmentedStatus == SelectedEnum.sisyt) {
                    notifier.setToTBL001().insert();
                  } else if (selectedSegmentedStatus == SelectedEnum.syunyu) {
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
                  if (selectedSegmentedStatus == SelectedEnum.sisyt) {
                    notifier.setToTBL001().update();
                  } else if (selectedSegmentedStatus == SelectedEnum.syunyu) {
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
                textfield: TextField(
                    controller: _priceInputController,
                    //画面が開いたら自動でフォーカスされる
                    autofocus: true,
                    textAlign: TextAlign.right,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(color: MyColors.white, fontSize: 17),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      //境界線を設定しないとアンダーラインが表示されるので透明でもいいから境界線を設定
                      //何もしていない時の境界線
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: MyColors.jet.withOpacity(0.0),
                          )),
                      //入力時の境界線
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: MyColors.jet.withOpacity(0.0),
                          )),
                      prefixIcon: SizedBox(
                        width: 49,
                        height: 28,
                        child: Center(
                          child: Text(
                            label,
                            style: const TextStyle(
                                color: MyColors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                    // //領域外をタップでproviderを更新する
                    onTapOutside: (event) {
                      final price = _priceInputController.text != ''
                          ? int.parse(_priceInputController.text)
                          : 0;
                      //キーボードを閉じる
                      FocusScope.of(context).unfocus();
                    },
                    onEditingComplete: () {
                      //キーボードを閉じる
                      FocusScope.of(context).unfocus();
                    },

                    //0が入力されたらコントローラーを初期化する
                    onChanged: (value) {
                      if (value == '0') {
                        return _priceInputController.clear();
                      }
                    }),
              ),

              const SizedBox(height: 4.5),

              PriceInputField(
                label: label,
                textfield: TextField(
                  controller: _memoInputController,
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(color: MyColors.white, fontSize: 17),
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    //境界線を設定しないとアンダーラインが表示されるので透明でもいいから境界線を設定
                    //何もしていない時の境界線
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: MyColors.jet.withOpacity(0.0),
                        )),
                    //入力時の境界線
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: MyColors.jet.withOpacity(0.0),
                        )),
                    prefixIcon: const SizedBox(
                      width: 49,
                      height: 28,
                      child: Center(
                        child: Text(
                          'メモ',
                          style: TextStyle(color: MyColors.white, fontSize: 17),
                        ),
                      ),
                    ),
                  ),

                  //キーボードcloseで再描画が走っているので変更を更新してあげる必要あり
                  //領域外をタップでproviderを更新する
                  onTapOutside: (event) {
                    //キーボードを閉じる
                    FocusScope.of(context).unfocus();
                  },
                  onEditingComplete: () {
                    //キーボードを閉じる
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
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
