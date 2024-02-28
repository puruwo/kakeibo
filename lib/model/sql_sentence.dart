import 'tableNameKey.dart';

class SQLSentence {
  final initialCreateList = [
    '''
          INSERT INTO TBL201 (
            ${TBL201RecordKey().id},
            ${TBL201RecordKey().smallCategoryOrderKey},
            ${TBL201RecordKey().bigCategoryKey},
            ${TBL201RecordKey().displayedOrderInBig},
            ${TBL201RecordKey().categoryName},
            ${TBL201RecordKey().defaultDisplayed}) 
            VALUES(0, 0, 0, 0, '食費', 1),
                  (1, 1, 0, 1, 'コンビニ', 1),
                  (2, 2, 0, 2, '外食', 1),
                  (3, 3, 0, 3, '社食', 1),
                  (4, 4, 1, 0, '消耗品', 1),
                  (5, 5, 1, 1, '雑貨', 1),
                  (6, 6, 2, 0, '遊び', 1),
                  (7, 7, 2, 1, '飲み', 1),
                  (8, 8, 2, 2, 'ライブ', 1),
                  (9, 9, 2, 3, 'ご褒美', 1),
                  (10, 10, 3, 0, '交通費', 1),
                  (11, 11, 3, 1, '帰省', 1),
                  (12, 12, 4, 0, 'カット', 1),
                  (13, 13, 5, 0, '医療費', 1),
                  (14, 14, 6, 0, 'その他', 1);
            ''',
    '''
          INSERT INTO TBL202 (
            ${TBL202RecordKey().id},
            ${TBL202RecordKey().colorCode},
            ${TBL202RecordKey().bigCategoryName},
            ${TBL202RecordKey().resourcePath},
            ${TBL202RecordKey().displayOrder},
            ${TBL202RecordKey().isDisplayed}) 
            VALUES(0, 'FF7070', '食費', 'assets/images/icon_meal.svg', 0, 1),
                  (1, '21D19F', '日用品', 'assets/images/icon_commodity.svg', 1, 1),
                  (2, 'ED112B', '遊び娯楽', 'assets/images/icon_favo.svg', 2, 1),
                  (3, '2596FF', '交通費', 'assets/images/icon_transportation.svg', 3, 1),
                  (4, 'FFC857', '衣服美容', 'assets/images/icon_clothes.svg', 4, 1),
                  (5, 'B118C8', '医療費', 'assets/images/icon_medical.svg', 5, 1),
                  (6, '3E2F5B', '雑費', 'assets/images/icon_others.svg', 6, 1);
            ''',
            
  ];

  final batchCreateList = [];
}
