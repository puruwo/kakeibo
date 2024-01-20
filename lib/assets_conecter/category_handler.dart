import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryHandler {
  Map<int, String> iconSvgUrlFromBigCategoryNum = {
    //0=食費
    0: 'assets/images/icon_meal.svg',
    //1=日用品
    1: 'assets/images/icon_commodity.svg',
    //2=遊び娯楽
    2: 'assets/images/icon_favo.svg',
    //3=交通費
    3: 'assets/images/icon_transportation.svg',
    //4=衣服美容
    4: 'assets/images/icon_clothes.svg',
    //5=医療費
    5: 'assets/images/icon_medical.svg',
    //6=雑費
    6: 'assets/images/icon_others.svg',
  };

//DBに移植したい
  Map<int, int> bigCategoryNumFromCategoryNum = {
    0: 0,
    1: 0,
    2: 0,
    3: 0,
    4: 1,
    5: 1,
    6: 2,
    7: 2,
    8: 2,
    9: 2,
    10: 3,
    11: 3,
    12: 4,
    13: 5,
    14: 6,
  };

  Map<int, String> categoryNameFromNum = {
    0: '食費',
    1: 'コンビニ',
    2: '外食',
    3: '社食',
    4: '消耗品',
    5: '日用雑貨',
    6: '遊び',
    7: '飲み',
    8: 'ライブ',
    9: 'ご褒美',
    10: '交通費',
    11: '帰省',
    12: 'カット',
    13: '医療費',
    14: 'その他',
  };

  Map<int, String> getBigCategoryName = {
    0: '食費',
    1: '日用品',
    2: '遊び娯楽',
    3: '交通費',
    4: '衣服美容',
    5: '医療費',
    6: '雑費',
  };

  Widget iconGetter(int categoryNum,{double? height,double? width}) {
    int? bigCategoryNum = bigCategoryNumFromCategoryNum[categoryNum]!;
    String? url = iconSvgUrlFromBigCategoryNum[bigCategoryNum];
    Widget? iconBuff = FittedBox(
      fit: BoxFit.scaleDown,
      child: SvgPicture.asset(
        url!,
        semanticsLabel: 'categoryIcon',
        width: width,
        height: height,
      ),
    );
    Widget icon;
    if (iconBuff == null) {
      print('iconを取得できませんでした¥nカテゴリーNoを確認してください');
      icon = SizedBox(width: width, height: height);
    } else {
      icon = iconBuff;
    }
    return icon;
  }

  String categoryNameGetter(int categoryNum) {
    String? nameBuff = categoryNameFromNum[categoryNum];
    String name;
    if (nameBuff == null) {
      print('カテゴリー名を取得できませんでした¥nカテゴリーNoを確認してください');
      name = 'null';
    } else {
      name = nameBuff;
    }
    return name;
  }
}
