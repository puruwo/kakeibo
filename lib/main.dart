import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo/view/foundation.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: const Foundation(),
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        // アプリ全体にテキストサイズの制御を適用
        // builder: (context, child) => TextScaleFactor(child: child!),
      ),
    ),
  );
}
