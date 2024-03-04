import 'package:flutter/material.dart';

import 'package:kakeibo/constant/colors.dart';


class InputFieldBack extends StatelessWidget {
  const InputFieldBack({required this.label, required this.textfield, super.key});
  final String label;
  final TextField textfield;

  @override
  Widget build(BuildContext context) {

    //price入力フィールド
    return SizedBox(
      height: 40,
      width: 332,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.jet,
          borderRadius: BorderRadius.circular(8),
        ),
        child: textfield,
      ),
    );
  }
}
