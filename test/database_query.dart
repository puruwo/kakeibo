// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kakeibo/main.dart';
import 'package:kakeibo/model/database_helper.dart';
import 'package:kakeibo/model/tableNameKey.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    DatabaseHelper db = DatabaseHelper.instance;

    final a = Sqflite.firstIntValue(await db.query('''
    SELECT ${TBL004RecordKey().resourcePath} FROM ${TBL003RecordKey().tableName} a
    INNER JOIN ${TBL004RecordKey().tableName} b
    ON a.${TBL003RecordKey().bigCategoryKey} = b.${TBL004RecordKey().id}
    WHERE a.${TBL003RecordKey().id} = 6
    '''));

    print(a);
    expect(a, completion(equals({"value" : 6})));
  });
}
