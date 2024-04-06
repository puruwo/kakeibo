import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tableNameKey.dart';

DatabaseHelper db = DatabaseHelper.instance;

class CategoryHandler {

  Widget sisytIconGetter(int categoryOrderKey, {double? height, double? width}) {
    final futureListMap = db.query('''
    SELECT ${TBL202RecordKey().resourcePath} FROM ${TBL201RecordKey().tableName} a
    INNER JOIN ${TBL202RecordKey().tableName} b
    ON a.${TBL201RecordKey().bigCategoryKey} = b.${TBL202RecordKey().id}
    WHERE a.${TBL201RecordKey().smallCategoryOrderKey} = $categoryOrderKey
    ''');
    return FutureBuilder(
        future: futureListMap,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            String url = snapshot.data![0][TBL202RecordKey().resourcePath];
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

  Widget syunyuIconGetter(int categoryOrederKey, {double? height, double? width}) {
    final futureListMap = db.query('''
    SELECT ${TBL212RecordKey().resourcePath} FROM ${TBL211RecordKey().tableName} a
    INNER JOIN ${TBL212RecordKey().tableName} b
    ON a.${TBL211RecordKey().bigCategoryKey} = b.${TBL212RecordKey().id}
    WHERE a.${TBL211RecordKey().smallCategoryOrderKey} = $categoryOrederKey
    ''');
    return FutureBuilder(
        future: futureListMap,
        builder: (context, snapshot) {
          if (snapshot.data != null ) {
            String url = snapshot.data![0][TBL212RecordKey().resourcePath];
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

  Widget iconGetterFromPath(String path, {double? height, double? width}) {
            String url = path;
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
        }

  Future<String> sisytBigCategoryNameGetter(int categoryId) async {
    final futureListMap = await db.query('''
    SELECT ${TBL202RecordKey().bigCategoryName} FROM ${TBL202RecordKey().tableName} a
    WHERE a.${TBL202RecordKey().id} = $categoryId
    ''');
    String categoryName = futureListMap[0][TBL202RecordKey().bigCategoryName];
    return categoryName;
  }

  Future<String> sisytCategoryNameGetter(int categoryId) async {
    final futureListMap = await db.query('''
    SELECT ${TBL201RecordKey().categoryName} FROM ${TBL201RecordKey().tableName} a
    WHERE a.${TBL201RecordKey().id} = $categoryId
    ''');
    String categoryName = futureListMap[0][TBL201RecordKey().categoryName];
    return categoryName;
  }

  Future<String> syunyuBigCategoryNameGetter(int categoryId) async {
    final futureListMap = await db.query('''
    SELECT ${TBL212RecordKey().bigCategoryName} FROM ${TBL212RecordKey().tableName} a
    WHERE a.${TBL212RecordKey().id} = $categoryId
    ''');
    String categoryName = futureListMap[0][TBL212RecordKey().bigCategoryName];
    return categoryName;
  }

  Future<String> syunyuCategoryNameGetter(int categoryId) async {
    final futureListMap = await db.query('''
    SELECT ${TBL211RecordKey().categoryName} FROM ${TBL211RecordKey().tableName} a
    WHERE a.${TBL211RecordKey().id} = $categoryId
    ''');
    String categoryName = futureListMap[0][TBL211RecordKey().categoryName];
    return categoryName;
  }
}
