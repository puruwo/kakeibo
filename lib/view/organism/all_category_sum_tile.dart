import 'package:flutter/material.dart';

import 'package:kakeibo/constant/colors.dart';

import 'package:kakeibo/model/assets_conecter/category_handler.dart';
import 'package:kakeibo/model/tableNameKey.dart';
import 'package:kakeibo/view_model/category_sum_getter.dart';

class AllCategorySumTile extends StatefulWidget {
  const AllCategorySumTile(
      {
      required this.bigCategoryInformationMaps,
      required this.allCategorySum,
      required this.allCategoryBudgetSum,
      super.key});

  // ['big_category_name'] ['sum_price'] ['icon'] ['color']
  final List<Map<String,dynamic>> bigCategoryInformationMaps;

  final int allCategorySum;
  final int allCategoryBudgetSum;

  final double barFrameWidth = 200.0;

  @override
  State<AllCategorySumTile> createState() => _CategorySumTileState();
}

class _CategorySumTileState extends State<AllCategorySumTile>
    with SingleTickerProviderStateMixin {
  //横棒グラフの初期値
  double barWidth = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //ビルドが完了したら横棒グラフのサイズを変更しアニメーションが動く
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        double degrees = (widget.allCategorySum / widget.allCategoryBudgetSum);
        barWidth = degrees <= 1.0
            ? widget.barFrameWidth * degrees
            : widget.barFrameWidth;
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
                        width: widget.barFrameWidth,
                        color: MyColors.white,
                      ),
                      AnimatedContainer(
                        height: 15,
                        width: barWidth,
                        color: MyColors.red,
                        duration: const Duration(milliseconds: 500),
                      ),
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
                ...List.generate(widget.bigCategoryInformationMaps.length, (index) {
                  return Row(
                    children: [
                      Text(
                        widget.bigCategoryInformationMaps[index]
                            [TBL202RecordKey().bigCategoryName],
                        style: const TextStyle(color: MyColors.white),
                      ),
                      Text(
                        widget.bigCategoryInformationMaps[index]['sum_by_big_category']
                            .toString(),
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
