// /// packegeImport
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter/material.dart';

// /// localImport
// import 'package:kakeibo/constant/colors.dart';

// import 'package:kakeibo/model/tbl_impl.dart';

// class BedgetSettingPage extends ConsumerStatefulWidget {
//   const BedgetSettingPage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _BedgetSettingPageState();
// }

// class _BedgetSettingPageState extends ConsumerState<BedgetSettingPage> {
//   final activeDt = DateTime.now();
//   late  Future<List<Map<String, dynamic>>> monthlyCategoryBudgetListFuture; 
//   final List<TextEditingController> controllerList = [];

//   @override
//   Widget build(BuildContext context) {
//     monthlyCategoryBudgetListFuture = queryMonthlyCategoryBudget(activeDt);
//     return FutureBuilder(
//         future: monthlyCategoryBudgetListFuture,
//         builder: (BuildContext context,
//             AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {

          

//           Widget children;

//           if (snapshot.hasData) {
//             final monthlyCategoryBudgetList = snapshot.data!;

//             return Expanded(
//               child: ListView.builder(
//                 controller: widget._scrollController,
//                 itemCount: sortedGroupedMap.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   String date = sortedGroupedMap.keys.elementAt(index);
//                   List<Map> itemsInADay = sortedGroupedMap[date]!;
//                   List<Map> descendingOrderItems =
//                       descendingOrderSort(itemsInADay);

//                   final stringDate = formattedLabelDateGetter(date);
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // 日付ヘッダーの上スペース
//                       const SizedBox(
//                         height: 13,
//                       ),
//                       //日付ラベル
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 14.5),
//                             child: Text(stringDate,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: MyColors.secondaryLabel,
//                                 )),
//                           ),
//                           //右余白
//                         ],
//                       ),

//                       //区切り線
//                       const Divider(
//                         thickness: 0.25,
//                         height: 0.25,
//                         indent: 14.5,
//                         color: MyColors.separater,
//                       ),

//                       //タイル
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: const ClampingScrollPhysics(),
//                         itemCount: descendingOrderItems.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           final item = itemsInADay[index];

//                           // アイコン
//                           final icon = CategoryHandler().sisytIconGetter(
//                               item[TBL001RecordKey().paymentCategoryId]);
//                           // 大カテゴリー名
//                           final bigCategoryName =
//                               item[TBL202RecordKey().bigCategoryName];
//                           // 小カテゴリー
//                           final categoryName =
//                               item[TBL201RecordKey().categoryName];
//                           // メモ
//                           final memo = item[TBL001RecordKey().memo];
//                           // 値段ラベル
//                           final priceLabel = formattedPriceGetter(
//                               item[TBL001RecordKey().price]);

//                           return Column(
//                             children: [
//                               Dismissible(
//                                 // 右から左
//                                 direction: DismissDirection.endToStart,
//                                 key: Key(item[TBL001RecordKey().id].toString()),
//                                 dragStartBehavior: DragStartBehavior.start,

//                                 // 右スワイプ時の背景
//                                 background: Container(color: MyColors.black),

//                                 // 左スワイプ時の背景
//                                 secondaryBackground: Container(
//                                   color: MyColors.red,
//                                   child: const Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Padding(
//                                         // 削除時背景のアイコンのpadding
//                                         padding: EdgeInsets.only(right: 18.0),
//                                         child: Icon(
//                                           Icons.delete,
//                                           color: MyColors.systemGray,
//                                         ),
//                                       )),
//                                 ),
//                                 child: SizedBox(
//                                   height: 49,
//                                   width: double.infinity,
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       // アイコン
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 20, right: 18),
//                                         child: icon,
//                                       ),

//                                       // 大カテゴリー、小カテゴリーのColumn
//                                       Expanded(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             // 大カテゴリー
//                                             Text(
//                                               bigCategoryName,
//                                               textAlign: TextAlign.end,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                 fontSize: 15,
//                                                 color: MyColors.secondaryLabel,
//                                               ),
//                                             ),

//                                             // 小カテゴリーとメモ
//                                             Row(
//                                               children: [
//                                                 // 小カテゴリー
//                                                 SizedBox(
//                                                   width: 60,
//                                                   child: Text(
//                                                     ' $categoryName',
//                                                     textAlign: TextAlign.start,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: const TextStyle(
//                                                         fontSize: 12,
//                                                         color: MyColors
//                                                             .tirtiaryLabel),
//                                                   ),
//                                                 ),
//                                                 // メモ
//                                                 SizedBox(
//                                                   width: 100,
//                                                   child: Text(
//                                                     ' $memo',
//                                                     textAlign: TextAlign.start,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: const TextStyle(
//                                                         fontSize: 12,
//                                                         color: MyColors
//                                                             .tirtiaryLabel),
//                                                   ),
//                                                 ),
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       ),

//                                       // 値段
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(right: 22.0),
//                                         child: Text(
//                                           priceLabel,
//                                           textAlign: TextAlign.end,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               fontSize: 19,
//                                               color: MyColors.label),
//                                         ),
//                                       ),

//                                       // nextArrowアイコン
//                                       const Padding(
//                                         padding: EdgeInsets.only(right: 20),
//                                         child: Icon(
//                                           size: 18,
//                                           Icons.arrow_forward_ios_rounded,
//                                           color: MyColors.white,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ), //区切り線
//                               const Divider(
//                                 thickness: 0.25,
//                                 height: 0.25,
//                                 indent: 50,
//                                 color: MyColors.separater,
//                               )
//                             ],
//                           );
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             );
//           } else if (snapshot.hasError) {
//             children = Container(
//                 child: const Text(
//               'データが見つかりません',
//               style: TextStyle(color: MyColors.white),
//             ));
//           } else {
//             children = const CircularProgressIndicator();
//           }

//           return children;
//         });
//   }
// }
