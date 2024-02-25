import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/view_model/provider/torok_state/torok_state.dart';

class MemoInputField extends ConsumerWidget {
  const MemoInputField({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //recordの値を取得
    final provider = ref.watch(torokRecordNotifierProvider);

    final TextEditingController memoInputController = TextEditingController(text: provider.memo);
    memoInputController.selection = TextSelection.fromPosition(TextPosition(offset: memoInputController.text.length));

    return SizedBox(
      height: 40,
      width: 332,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.jet,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: memoInputController,
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
            //providerを更新
            final memo = memoInputController.text;
            final notifier = ref.read(torokRecordNotifierProvider.notifier);
            notifier.updateMemo(memo);
            //キーボードを閉じる
            FocusScope.of(context).unfocus();
          },
          onEditingComplete: () {
            //providerを更新
            final memo = memoInputController.text;
            final notifier = ref.read(torokRecordNotifierProvider.notifier);
            notifier.updateMemo(memo);
            //キーボードを閉じる
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }
}
