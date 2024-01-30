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
      ),
    ),
  );
}