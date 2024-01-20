import 'package:flutter/material.dart';
import 'package:kakeibo/assets_conecter/category_handler.dart';
import 'package:kakeibo/model/tableNameKey.dart';

Widget modelToWidget(BuildContext ctx, Map separateLabelMap) {
//Mapより
  int categoryNum = separateLabelMap[SeparateLabelMapKey().category];
  int year = separateLabelMap[SeparateLabelMapKey().year];
  int month = separateLabelMap[SeparateLabelMapKey().month];
  int day = separateLabelMap[SeparateLabelMapKey().day];
  int price = separateLabelMap[SeparateLabelMapKey().price];
  String memo = separateLabelMap[SeparateLabelMapKey().memo];

//カテゴリー名取得
  String categoryName = CategoryHandler().categoryNameGetter(categoryNum);
  Widget icon = CategoryHandler().iconGetter(categoryNum);

//切り出しする----------------------------------------------------------------------

  final categoryNameLabel = Container(
    padding: const EdgeInsets.all(8),
    alignment: Alignment.center,
    child: Text(
      categoryName,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  final priceLabel = Container(
    padding: const EdgeInsets.all(6),
    alignment: Alignment.center,
    child: Text(
      price.toString(),
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
//--------------------------------------------------------------------------------

  return Container(
    padding: const EdgeInsets.all(1),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.blue,
      ),
      color: Colors.white,
    ),
    width: double.infinity,
    height: 60,
    child: Row(children: [
      icon,
      categoryNameLabel,
      priceLabel,
    ]),
  );
}
