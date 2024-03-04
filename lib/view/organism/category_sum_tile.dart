import 'package:flutter/material.dart';

import 'package:kakeibo/constant/colors.dart';

import 'package:kakeibo/model/assets_conecter/category_handler.dart';
import 'package:kakeibo/model/tableNameKey.dart';
import 'package:kakeibo/view_model/category_sum_getter.dart';

class CategorySumTile extends StatefulWidget {
  const CategorySumTile(
      {required this.icon,
      required this.categoryName,
      required this.bigCategorySum,
      required this.budget,
      required this.smallCategorySumList,
      super.key});

  final Widget icon;
  final String categoryName;
  final int bigCategorySum;
  final int budget;
  final List<Map<String, dynamic>> smallCategorySumList;

  final double barFrameWidth = 200.0;

  @override
  State<CategorySumTile> createState() => _CategorySumTileState();
}

class _CategorySumTileState extends State<CategorySumTile>
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
        double degrees = (widget.bigCategorySum / widget.budget);
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
                      widget.icon,
                      Text(
                        widget.categoryName,
                        style: const TextStyle(color: MyColors.white),
                      ),
                      Text(
                        widget.bigCategorySum.toString(),
                        style: const TextStyle(color: MyColors.white),
                      ),
                      const Text(
                        '/',
                        style: TextStyle(color: MyColors.white),
                      ),
                      Text(
                        widget.budget.toString(),
                        style: const TextStyle(color: MyColors.white),
                      )
                    ],
                  ),
                ],
              ),
              children: [
                ...List.generate(widget.smallCategorySumList.length, (index) {
                  return Row(
                    children: [
                      Text(
                        widget.smallCategorySumList[index]
                            [TBL201RecordKey().categoryName],
                        style: const TextStyle(color: MyColors.white),
                      ),
                      Text(
                        widget.smallCategorySumList[index]['small_category_payment_sum']
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
