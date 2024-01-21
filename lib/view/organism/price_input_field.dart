import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';

import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/view_model/provider/tbl001_state/tbl001_state.dart';

class PriceInputField extends ConsumerWidget {
  const PriceInputField({required this.label, super.key});
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //recordの値を取得
    //TextFieldのonTapOutsideが呼び出された時にリビルドがかかり、controllerが初期化されるため同期する必要がある
    final provider = ref.read(tBL001RecordNotifierProvider);
    final TextEditingController priceInputController = TextEditingController(text: '${provider.price}');
    priceInputController.selection = TextSelection.fromPosition(TextPosition(offset: priceInputController.text.length), );

    //price入力フィールド
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
                  style: const TextStyle(color: MyColors.white, fontSize: 17),
                ),
              ),
            ),
          ),

          //キーボードを閉じる
          // onTapOutside: (event) => FocusScope.of(context).unfocus(),

          onChanged: (value) {
            // テキストが変更されたときに呼ばれる関数

            //コントローラーの値が変わるたびに
            //コントローラーの値をtbl001recordに代入する
            //watchにしやんのはtextEditingControllerが変化した時にリビルドされてるから

            final price;

            //priceがnullじゃなければ更新
            if (priceInputController.text != '') {
              price = int.parse(priceInputController.text);
              //tbl001_recordのnotifierを取得
              final notifier = ref.read(tBL001RecordNotifierProvider.notifier);
              //更新
              notifier.updatePrice(price);
            }
          },
          //controllerチェック、数値入力されているか
          controller: priceInputController,
        ),
      ),
    );
  }
}
