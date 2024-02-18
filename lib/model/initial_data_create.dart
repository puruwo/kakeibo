import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/repository/tbl001_record/tbl001_record.dart';
import 'package:kakeibo/repository/tbl002_record/tbl002_record.dart';
import 'package:kakeibo/repository/tbl003_record/tbl003_record.dart';
import 'package:kakeibo/repository/tbl004_record/tbl004_record.dart';

class InitialDataCreate{
  List<Map<String,dynamic>> tBL003RecordsMap = [
    const TBL003Record(id: 0, smallCategoryKey: 0, bigCategoryKey: 0, categoryName: '食費', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 1, smallCategoryKey: 1, bigCategoryKey: 0, categoryName: 'コンビニ', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 2, smallCategoryKey: 2, bigCategoryKey: 0, categoryName: '外食', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 3, smallCategoryKey: 3, bigCategoryKey: 0, categoryName: '社食', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 4, smallCategoryKey: 4, bigCategoryKey: 1, categoryName: '消耗品', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 5, smallCategoryKey: 5, bigCategoryKey: 1, categoryName: '雑貨', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 6, smallCategoryKey: 6, bigCategoryKey: 2, categoryName: '遊び', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 7, smallCategoryKey: 7, bigCategoryKey: 2, categoryName: '飲み', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 8, smallCategoryKey: 8, bigCategoryKey: 2, categoryName: 'ライブ', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 9, smallCategoryKey: 9, bigCategoryKey: 2, categoryName: 'ご褒美', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 10, smallCategoryKey: 10, bigCategoryKey: 3, categoryName: '交通費', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 11, smallCategoryKey: 11, bigCategoryKey: 3, categoryName: '帰省', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 12, smallCategoryKey: 12, bigCategoryKey: 4, categoryName: 'カット', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 13, smallCategoryKey: 13, bigCategoryKey: 5, categoryName: '医療費', defaultDisplayed: 1).toJson(),
    const TBL003Record(id: 14, smallCategoryKey: 14, bigCategoryKey: 6, categoryName: 'その他', defaultDisplayed: 1).toJson(),
  ];

  List<Map<String,dynamic>> tBL004RecordsMap = [
    const TBL004Record(id: 0, colorCode: 'FF7070', bigCategoryName: '食費', resourcePath: 'assets/images/icon_meal.svg', displayOrder: 0, isDisplayed: 1).toJson(),
    const TBL004Record(id: 1, colorCode: '21D19F', bigCategoryName: '日用品', resourcePath: 'assets/images/icon_commodity.svg', displayOrder: 1, isDisplayed: 1).toJson(),
    const TBL004Record(id: 2, colorCode: 'ED112B', bigCategoryName: '遊び娯楽', resourcePath: 'assets/images/icon_favo.svg', displayOrder: 2, isDisplayed: 1).toJson(),
    const TBL004Record(id: 3, colorCode: '2596FF', bigCategoryName: '交通費', resourcePath: 'assets/images/icon_transportation.svg', displayOrder: 3, isDisplayed: 1).toJson(),
    const TBL004Record(id: 4, colorCode: 'FFC857', bigCategoryName: '衣服美容', resourcePath: 'assets/images/icon_clothes.svg', displayOrder: 4, isDisplayed: 1).toJson(),
    const TBL004Record(id: 5, colorCode: 'B118C8', bigCategoryName: '医療費', resourcePath: 'assets/images/icon_medical.svg', displayOrder: 5, isDisplayed: 1).toJson(),
    const TBL004Record(id: 6, colorCode: '3E2F5B', bigCategoryName: '雑費', resourcePath: 'assets/images/icon_others.svg', displayOrder: 6, isDisplayed: 1).toJson(),
  ];
}