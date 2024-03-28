import 'package:intl/intl.dart';


// 値段をカンマ区切りフォーマットで出力する処理

String formattedPriceGetter(int price) {
  mathFunc(Match match) => '${match[1]},';
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String stringPrice = price.toString();
  String result = stringPrice.replaceAllMapped(reg, mathFunc);
  return result;
}
String yenmarkFormattedPriceGetter(int price) {
  mathFunc(Match match) => '${match[1]},';
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String stringPrice = price.toString();
  String result = stringPrice.replaceAllMapped(reg, mathFunc);
  return '¥ $result';
}
String yenFormattedPriceGetter(int price) {
  mathFunc(Match match) => '${match[1]},';
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String stringPrice = price.toString();
  String result = stringPrice.replaceAllMapped(reg, mathFunc);
  return '$result 円';
}
