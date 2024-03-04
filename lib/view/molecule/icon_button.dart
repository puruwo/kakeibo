import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo/model/assets_conecter/category_handler.dart';

import 'package:kakeibo/constant/colors.dart';

// class AuntIconButton extends ConsumerWidget {
//   final Image img;
//   final Function onTap;
//   const AuntIconButton({
//     required this.img,
//     required this.onTap,
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ElevatedButton(
//       //アクティブか否かの実装

//       onPressed: () => onTap,
//       child: SizedBox(
//         height: 30,
//         width: 30,
//         child: img,
//       ),
//     );
//   }
// }

class CategoryIconButton extends ConsumerWidget {
  final int buttonInfo;
  final bool isSelected;
  const CategoryIconButton({
    this.buttonInfo = -1,
    this.isSelected = false,
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
                        isSelected == false ? MyColors.jet : MyColors.dimGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CategoryHandler()
                      .iconGetter(buttonInfo, height: 25, width: 25),
                ),
              )
            : SizedBox(
                height: 44,
                width: 64,
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

        // ボタンが空じゃなければ
        buttonInfo != -1
            ?
            //テキストラベル
            FutureBuilder(
                future: CategoryHandler().categoryNameGetter(buttonInfo),
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
            // ボタンが空なら
            : Container()
      ],
    );
  }
}
