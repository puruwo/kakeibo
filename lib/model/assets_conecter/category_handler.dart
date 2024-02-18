import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tableNameKey.dart';

DatabaseHelper db = DatabaseHelper.instance;

class CategoryHandler {

  Widget iconGetter(int categoryId, {double? height, double? width}) {
    final futureListMap = db.query('''
    SELECT ${TBL004RecordKey().resourcePath} FROM ${TBL003RecordKey().tableName} a
    INNER JOIN ${TBL004RecordKey().tableName} b
    ON a.${TBL003RecordKey().bigCategoryKey} = b.${TBL004RecordKey().id}
    WHERE a.${TBL003RecordKey().id} = $categoryId
    ''');
    return FutureBuilder(
        future: futureListMap,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            String url = snapshot.data![0][TBL004RecordKey().resourcePath];
            Widget icon = FittedBox(
              fit: BoxFit.scaleDown,
              child: SvgPicture.asset(
                url,
                semanticsLabel: 'categoryIcon',
                width: width,
                height: height,
              ),
            );
            return icon;
          } else {
            return SizedBox(width: width, height: height);
          }
        });
  }

  Future<String> categoryNameGetter(int categoryId) async {
    final futureListMap = await db.query('''
    SELECT ${TBL003RecordKey().categoryName} FROM ${TBL003RecordKey().tableName} a
    WHERE a.${TBL003RecordKey().id} = $categoryId
    ''');
    String categoryName = futureListMap[0][TBL003RecordKey().categoryName];
    return categoryName;
  }
}
