import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo/view/foundation.dart';

void main() {
  //firstviewの設定ページindex


  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: Foundation(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}