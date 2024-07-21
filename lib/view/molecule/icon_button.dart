import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kakeibo/constant/colors.dart';

class CategoryIconButton extends ConsumerWidget {
  final int buttonInfo;
  final bool isSelected;
  final Widget icon;
  final String label;
  const CategoryIconButton({
    this.buttonInfo = -1,
    this.isSelected = false,
    required this.icon,
    this.label = '',
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        //アイコンボタン本体
        buttonInfo != -1
            //非選択状態
            ? SizedBox(
                height: 44,
                width: 64,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        //非選択状態 or 選択状態
                        isSelected == false ? MyColors.secondarySystemfill : MyColors.systemGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: icon,
                ),
              )
            : SizedBox(
                height: 44,
                width: 64,
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

        //テキストラベル

        Text(
          label,
          style: const TextStyle(color: MyColors.white),
        )
      ],
    );
  }
}
