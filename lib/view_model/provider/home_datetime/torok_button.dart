import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kakeibo/view/atom/torok_button_atom.dart';
import 'package:kakeibo/view_model/provider/tbl001_state/tbl001_state.dart';

class TorokButton extends HookConsumerWidget {
  const TorokButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //recordの状態を取得
    final notifier = ref.read(tBL001RecordNotifierProvider.notifier);

    return TorokButtonAtom(
      
      //recordのメソッドからテーブルに挿入
      function: () => notifier.insertToTable(),
    );
  }
}
