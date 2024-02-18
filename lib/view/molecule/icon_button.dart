import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo/model/assets_conecter/category_handler.dart';

import 'package:kakeibo/constant/colors.dart';

class AuntIconButton extends ConsumerWidget {
  final Image img;
  final Function onTap;
  const AuntIconButton({
    required this.img,
    required this.onTap,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      //アクティブか否かの実装

      onPressed: () => onTap,
      child: SizedBox(
        height: 30,
        width: 30,
        child: img,
      ),
    );
  }
}

class CategoryIconButton extends ConsumerWidget {
  final int buttonNumber;
  final bool isSelected;
  const CategoryIconButton({
    required this.buttonNumber,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        //アイコンボタン本体
        isSelected == false
            //非選択状態
            ? SizedBox(
                height: 44,
                width: 64,
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.jet,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CategoryHandler()
                      .iconGetter(buttonNumber, height: 25, width: 25),
                ),
              )
            //選択状態
            : SizedBox(
                height: 44,
                width: 64,
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.dimGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CategoryHandler()
                      .iconGetter(buttonNumber, height: 25, width: 25),
                ),
              ),

        //テキストラベル
        FutureBuilder(
            future: CategoryHandler().categoryNameGetter(buttonNumber),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Text(
                  snapshot.data!,
                  style: const TextStyle(color: MyColors.white),
                );
              } else {
                return const Text('');
              }
            })
      ],
    );
  }
}
