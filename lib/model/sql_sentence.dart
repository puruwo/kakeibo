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
    '''          
          CREATE TABLE ${TBL005RecordKey().tableName} (
            ${TBL005RecordKey().id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${TBL005RecordKey().yyyy} INTEGER NOT NULL,
            ${TBL005RecordKey().mm} INTEGER NOT NULL,
            ${TBL005RecordKey().bigCategoryId} INTEGER NOT NULL,
            ${TBL005RecordKey().price} INTEGER
          )
          ;
    '''
    ,
    '''
          INSERT INTO TBL005 (
            ${TBL005RecordKey().id},
            ${TBL005RecordKey().yyyy},
            ${TBL005RecordKey().mm},
            ${TBL005RecordKey().bigCategoryId},
            ${TBL005RecordKey().price}) 
            VALUES(0,2024,1,0,35000),
            (1,2024,1,1,5000),
            (2,2024,1,2,32000),
            (3,2024,1,3,9000),
            (4,2024,1,4,15000),
            (5,2024,1,5,0),
            (6,2024,1,6,5000)
            ;
      '''
  ];
}
