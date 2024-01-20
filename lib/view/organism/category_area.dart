import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kakeibo/view/molecule/icon_button.dart';
import 'package:kakeibo/view_model/provider/tbl001_state/tbl001_state.dart';

class CategoryArea extends HookConsumerWidget {
  const CategoryArea({super.key});

  @override
  Widget build(context, WidgetRef ref) {
//状態管理---------------------------------------------------------------------------------------

    final activeButtonNumberProvider = ref.watch(
        tBL001RecordNotifierProvider.select((record) => record.category));
    final activeButtonNumberNotifier =
        ref.watch(tBL001RecordNotifierProvider.notifier);

//----------------------------------------------------------------------------------------------

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          3, //3行の意味
          (columnIndex) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //indexの実装
              children: List.generate(
                5, //1列5個の意味

                (rowIndex) {
                  //ボタンの番号(0~14)
                  final buttonNumber = columnIndex * 5 + rowIndex;
                  //ボタン番号とrecordが持つボタン番号が一致しているかの判定をする、選択状態かどうかを決める
                  final isSelected =
                      (buttonNumber == activeButtonNumberProvider);

                  return GestureDetector(
                    onTap: () {
                      //状態の更新
                      activeButtonNumberNotifier.updateCategory(buttonNumber);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: CategoryIconButton(
                        //nullチェックどうするか考え直す
                        buttonNumber: buttonNumber,
                        isSelected: isSelected,
                      ),
                    ),
                  );
                },

              )),
        ));
  }
}
