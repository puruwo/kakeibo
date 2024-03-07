import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:kakeibo/constant/colors.dart';

import 'package:kakeibo/model/assets_conecter/category_handler.dart';
import 'package:kakeibo/model/tableNameKey.dart';
import 'package:kakeibo/view_model/category_sum_getter.dart';

class AllCategorySumTile extends StatefulWidget {
  const AllCategorySumTile(
      {required this.bigCategoryInformationMaps,
      required this.allCategorySum,
      required this.allCategoryBudgetSum,
      super.key});

  // ['big_category_name'] ['payment_price_sum'] ['icon'] ['color']
  final List<Map<String, dynamic>> bigCategoryInformationMaps;
  // 全カテゴリーの合計支出
  final int allCategorySum;
  // 前カテゴリーの合計予算
  final int allCategoryBudgetSum;

  @override
  State<AllCategorySumTile> createState() => _CategorySumTileState();
}

class _CategorySumTileState extends State<AllCategorySumTile>
    with SingleTickerProviderStateMixin {

  // ビルドが完了したかどうか
  bool _isBuilt = false;

  // 横棒グラフのフレームサイズ
  final double barFrameWidth = 200.0;

  late List<double> barWidthList;

  @override
  void initState() {
    // 各カテゴリーの棒グラフの幅リストを初期化
    barWidthList =
        List.generate(widget.bigCategoryInformationMaps.length, (index) => 0);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // 各大カテゴリーの名前
    List<String> bigCategoryNameList = [];
    // 各大カテゴリー支出合計のリスト
    List<int> paymentPriceSumList = [];
    // 各大カテゴリーのアイコン
    List<Widget> iconList = [];
    // 各大カテゴリーのカラー
    List<Color> colorList = [];
    // 情報を展開
    for (var value in widget.bigCategoryInformationMaps) {
      bigCategoryNameList.add(value[TBL202RecordKey().bigCategoryName]);
      paymentPriceSumList.add(value['payment_price_sum']);
      // iconList.add(value['icon']);
      colorList
          .add(MyColors().getColorFromHex(value[TBL202RecordKey().colorCode]));
    }

    // 角カテゴリーのグラフ幅を計算
    for (int i = 0; i < barWidthList.length; i++) {
      double degrees = (paymentPriceSumList[i] / widget.allCategoryBudgetSum);
      barWidthList[i] = degrees <= 1.0
          ? barFrameWidth * degrees
          : barFrameWidth;
    }

    //ビルドが完了したら横棒グラフのサイズを変更しアニメーションが動く
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isBuilt = true;
      });
    });

    return Container(
      decoration: BoxDecoration(
        color: MyColors.jet,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          //themeでwrapするExpansionTileの線が消える
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              listTileTheme: ListTileTheme.of(context).copyWith(
                titleAlignment: ListTileTitleAlignment.center,
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                dense: true,
              ),
            ),
            child: ExpansionTile(
              iconColor: MyColors.mint,
              collapsedIconColor: MyColors.mint,
              title: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 15,
                        width: barFrameWidth,
                        color: MyColors.white,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...List.generate(
                                widget.bigCategoryInformationMaps.length,
                                (index) {
                              return AnimatedContainer(
                                height: 15,
                                width: _isBuilt ? barWidthList[index] : 0,
                                color: colorList[index],
                                duration: const Duration(milliseconds: 500),
                              );
                            }),
                          ])
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        '全体',
                        style: const TextStyle(color: MyColors.white),
                      ),
                      Text(
                        widget.allCategorySum.toString(),
                        style: const TextStyle(color: MyColors.white),
                      ),
                      const Text(
                        '/',
                        style: TextStyle(color: MyColors.white),
                      ),
                      Text(
                        widget.allCategoryBudgetSum.toString(),
                        style: const TextStyle(color: MyColors.white),
                      )
                    ],
                  ),
                ],
              ),
              children: [
                ...List.generate(widget.bigCategoryInformationMaps.length,
                    (index) {
                  return Row(
                    children: [
                      Text(
                        bigCategoryNameList[index],
                        style: const TextStyle(color: MyColors.white),
                      ),
                      Text(
                        paymentPriceSumList[index].toString(),
                        style: const TextStyle(color: MyColors.white),
                      ),
                    ],
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
