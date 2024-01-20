import 'package:flutter/material.dart';
import 'package:kakeibo/model/tbl001_impl.dart';

testbutton() {
  return ElevatedButton(
    onPressed: () async {
      final allRows = await TBL001Impl().queryAllRows();
      print('全てのデータを照会しました。');
      print(allRows);
      allRows.forEach(print);
    },
    child: const Text('照会'),
  );
}
