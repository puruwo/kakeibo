import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/view_model/provider/tbl001_state/tbl001_state.dart';

class MemoInputField extends ConsumerWidget {
  const MemoInputField({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //recordの値を取得
    //TextFieldのonTapOutsideが呼び出された時にリビルドがかかり、controllerが初期化されるため同期する必要がある
    final provider = ref.read(tBL001RecordNotifierProvider);
    final TextEditingController memoInputController =
        TextEditingController(text: provider.memo);

    return SizedBox(
      height: 40,
      width: 332,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.jet,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
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

          // onChanged: (value) {

          // },
          //キーボードを閉じる
          onTapOutside: (event) => FocusScope.of(context).unfocus(),

          onChanged: (value) {
            final memo = memoInputController.text;

            //tbl001_recordのnotifierを取得
            final notifier = ref.read(tBL001RecordNotifierProvider.notifier);

            //更新
            notifier.updateMemo(memo);
          },

          controller: memoInputController,
        ),
      ),
    );
  }
}
