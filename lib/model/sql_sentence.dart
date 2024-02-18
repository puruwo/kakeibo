import 'tableNameKey.dart';

class SQLSentence {
  final initialCreateList = [
    '''
          CREATE TABLE ${TBL001RecordKey().tableName} (
            ${TBL001RecordKey().id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${TBL001RecordKey().year} INTEGER NOT NULL,
            ${TBL001RecordKey().month} INTEGER NOT NULL,
            ${TBL001RecordKey().day} INTEGER NOT NULL,
            ${TBL001RecordKey().price} INTEGER NOT NULL,
            ${TBL001RecordKey().paymentCategoryId} INTEGER NOT NULL,
            ${TBL001RecordKey().memo} TEXT
          )
          ;
          ''',
    '''
          CREATE TABLE ${TBL002RecordKey().tableName} (
            ${TBL002RecordKey().id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${TBL002RecordKey().year} INTEGER NOT NULL,
            ${TBL002RecordKey().month} INTEGER NOT NULL,
            ${TBL002RecordKey().day} INTEGER NOT NULL,
            ${TBL002RecordKey().price} INTEGER NOT NULL,
            ${TBL002RecordKey().incomeCategoryId} INTEGER NOT NULL,
            ${TBL002RecordKey().memo} TEXT
          )
          ;
          ''',
    '''
          CREATE TABLE ${TBL003RecordKey().tableName} (
            ${TBL003RecordKey().id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${TBL003RecordKey().smallCategoryKey} INTEGER NOT NULL,
            ${TBL003RecordKey().bigCategoryKey} INTEGER NOT NULL,
            ${TBL003RecordKey().categoryName} TEXT NOT NULL,
            ${TBL003RecordKey().defaultDisplayed} INTEGER NOT NULL
          )
          ;
          ''',
    '''          
          CREATE TABLE ${TBL004RecordKey().tableName} (
            ${TBL004RecordKey().id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${TBL004RecordKey().colorCode} TEXT NOT NULL,
            ${TBL004RecordKey().bigCategoryName} TEXT NOT NULL,
            ${TBL004RecordKey().resourcePath} TEXT NOT NULL,
            ${TBL004RecordKey().displayOrder} INTEGER NOT NULL,
            ${TBL004RecordKey().isDisplayed} INTEGER NOT NULL
          )
          ;'''
  ];

  final batchCreateList = [
  ];
}
